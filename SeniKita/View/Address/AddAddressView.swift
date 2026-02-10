//
//  AddAddressView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 08/02/26.
//

import SwiftUI
import CoreLocation

struct AddAddressView: View {
    
    @ObservedObject var addressViewModel: AddressViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isEditing: Bool
    @Binding var addressToEdit: Address?
    
    @State private var labelAddress: String = ""
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var postalCode: String = ""
    @State private var addressDetail: String = ""
    @State private var note: String = ""
    @State private var selectedProvince: Province? = nil
    @State private var selectedCity: City? = nil
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var geocodedAddress: String = ""
    @State private var geocodedProvince: String = ""
    @State private var geocodedCity: String = ""
    @State private var geocodedPostalCode: String = ""
    @State private var isGeocoding: Bool = false
    
    
    @State private var showSuccessPopup = false
    @State private var showErrorPopup = false
    @State private var popupMessage = ""
    @State private var isInitialLoading = true

    @FocusState private var focusedField: Field?
    
    enum Field {
        case phone
        case postalCode
    }
    
    private var isFormValid: Bool {
        return !labelAddress.isEmpty &&
        !name.isEmpty &&
        !phone.isEmpty &&
        !postalCode.isEmpty &&
        !addressDetail.isEmpty &&
        selectedProvince != nil &&
        selectedCity != nil
    }
    
    var body: some View {
        ZStack {
            if isInitialLoading {
                Loading(opacity: 1.0)
            } else {
                mainContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isEditing ? "Ubah Alamat" : "Tambah Alamat")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("brick"))
                }
            }
        }
        .hideTabBar()
        .onAppear {
            if addressViewModel.province.isEmpty {
                addressViewModel.getProvinces()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation {
                        isInitialLoading = false
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        isInitialLoading = false
                    }
                }
            }
            
            if let detail = addressToEdit {
                loadExistingAddress(detail)
            }
        }
    }
    
    private var mainContent: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    MapLocationPicker(
                        coordinate: $selectedCoordinate,
                        addressString: $geocodedAddress,
                        province: $geocodedProvince,
                        city: $geocodedCity,
                        postalCode: $geocodedPostalCode,
                        isGeocoding: $isGeocoding,
                        selectedProvinceName: selectedProvince?.name,
                        selectedCityName: selectedCity?.name
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                    .onChange(of: geocodedAddress) { newAddress in
                        if !newAddress.isEmpty {
                            addressDetail = newAddress
                        }
                    }
                    .onChange(of: geocodedPostalCode) { newPostalCode in
                        if !newPostalCode.isEmpty {
                            postalCode = newPostalCode
                        }
                    }
                    .disabled(selectedProvince == nil || selectedCity == nil)
                    
                    // Overlay when map is disabled
                    if selectedProvince == nil || selectedCity == nil {
                        Color.black.opacity(0.6)
                            .frame(height: UIScreen.main.bounds.height * 0.3)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Pilih Provinsi dan Kota terlebih dahulu")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                    }
                }
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Informasi Penerima")
                                .font(AppFont.Nunito.footnoteSmall)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            VStack(spacing: 0) {
                                FormField(
                                    label: "Label Alamat",
                                    text: $labelAddress,
                                    placeholder: "Rumah, Kantor, dll.",
                                    isFirst: true
                                )
                                
                                Divider().padding(.leading, 16)
                                
                                FormField(
                                    label: "Nama Penerima",
                                    text: $name,
                                    placeholder: "Masukkan nama lengkap"
                                )
                                
                                Divider().padding(.leading, 16)
                                
                                FormField(
                                    label: "Nomor Telepon",
                                    text: $phone,
                                    placeholder: "08xxxxxxxxxx",
                                    keyboardType: .phonePad,
                                    isLast: true
                                )
                                .focused($focusedField, equals: .phone)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Detail Alamat")
                                    .font(AppFont.Nunito.footnoteSmall)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                if isGeocoding {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                }
                            }
                            
                            VStack(spacing: 0) {
                                CustomPicker(
                                    label: "Provinsi",
                                    selection: $selectedProvince,
                                    options: addressViewModel.province,
                                    displayProperty: \.name
                                )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .onChange(of: selectedProvince) {
                                    if let provinceId = selectedProvince?.id {
                                        addressViewModel.getCitiesByIdProvinces(idProvinces: provinceId) {}
                                    }
                                    selectedCity = nil
                                }
                                
                                Divider().padding(.leading, 16)
                                
                                CustomPicker(
                                    label: "Kabupaten/Kota",
                                    selection: $selectedCity,
                                    options: addressViewModel.cityByProvince,
                                    displayProperty: \.name
                                )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .disabled(selectedProvince == nil)
                                .opacity(selectedProvince == nil ? 0.5 : 1)
                                
                                Divider().padding(.leading, 16)
                                
                                FormField(
                                    label: "Kode Pos",
                                    text: $postalCode,
                                    placeholder: "Masukkan kode pos",
                                    keyboardType: .numberPad
                                )
                                .focused($focusedField, equals: .postalCode)
                                
                                Divider().padding(.leading, 16)
                                
                                FormTextArea(
                                    label: "Alamat Lengkap",
                                    text: $addressDetail,
                                    placeholder: "Nama jalan, no. rumah, RT/RW, dll.",
                                    isLast: true
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        // Catatan (Opsional)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Catatan (Opsional)")
                                .font(AppFont.Nunito.footnoteSmall)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
                            VStack(spacing: 0) {
                                FormField(
                                    label: "Catatan",
                                    text: $note,
                                    placeholder: "Patokan, warna rumah, dll.",
                                    isFirst: true,
                                    isLast: true
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 80)
                }
                
                // Sticky Bottom Button
                VStack {
                    Button(action: submitForm) {
                        Text(isEditing ? "Simpan Perubahan" : "Simpan Alamat")
                            .font(AppFont.Nunito.subtitle)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isFormValid ? Color("brick") : Color.gray.opacity(0.4))
                            .cornerRadius(12)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .background(
                        Color(UIColor.systemGroupedBackground)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
                    )
                }
            }
            
            // Popups
            if showSuccessPopup {
                BasePopup(
                    isShowing: $showSuccessPopup,
                    message: popupMessage,
                    onConfirm: {
                        showSuccessPopup = false
                        presentationMode.wrappedValue.dismiss()
                    },
                    isSuccess: true
                )
                .zIndex(1)
            }
            
            if showErrorPopup {
                BasePopup(
                    isShowing: $showErrorPopup,
                    message: popupMessage,
                    onConfirm: {
                        showErrorPopup = false
                    },
                    isSuccess: false
                )
                .zIndex(1)
            }
            
            if addressViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            // Keyboard Toolbar
            if focusedField != nil {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            focusedField = nil // Dismiss keyboard
                        }) {
                            Text("Selesai")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(Color("brick"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 4, y: -2)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 8)
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.25), value: focusedField)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadExistingAddress(_ detail: Address) {
        self.labelAddress = detail.label_address
        self.name = detail.name
        self.phone = detail.phone
        self.postalCode = String(detail.postal_code)
        self.addressDetail = detail.address_detail
        self.note = detail.note ?? ""
        
        if !addressViewModel.province.isEmpty {
            self.selectedProvince = addressViewModel.province.first(where: { $0.id == detail.province_id })
        }
        
        if let provinceId = selectedProvince?.id {
            addressViewModel.getCitiesByIdProvinces(idProvinces: provinceId) {
                self.selectedCity = addressViewModel.cityByProvince.first(where: { $0.id == detail.city_id })
            }
        }
    }
    
    private func submitForm() {
        guard let provinceId = selectedProvince?.id, let cityId = selectedCity?.id else {
            popupMessage = "Provinsi atau Kota belum dipilih"
            showErrorPopup = true
            return
        }
        
        if isEditing, let address = addressToEdit {
            addressViewModel.updateAddress(
                idAddress: address.id,
                labelAddress: labelAddress,
                name: name,
                phone: phone,
                addressDetail: addressDetail,
                provinceId: provinceId,
                cityId: cityId,
                postalCode: postalCode,
                note: note
            ) { success, message in
                DispatchQueue.main.async {
                    popupMessage = message
                    if success {
                        showSuccessPopup = true
                    } else {
                        showErrorPopup = true
                    }
                }
            }
        } else {
            addressViewModel.addAddress(
                labelAddress: labelAddress,
                name: name,
                phone: phone,
                addressDetail: addressDetail,
                provinceId: provinceId,
                cityId: cityId,
                postalCode: postalCode,
                note: note
            ) { success, message in
                DispatchQueue.main.async {
                    popupMessage = message
                    if success {
                        showSuccessPopup = true
                    } else {
                        showErrorPopup = true
                    }
                }
            }
        }
    }
}
