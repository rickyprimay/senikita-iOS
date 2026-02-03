//
//  AddAddressSheet.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 18/03/25.
//

import SwiftUI

struct AddAddressSheet: View {
    
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
    
    @FocusState var labelFocusState: Bool
    @FocusState var nameFocusState: Bool
    @FocusState var phoneFocusState: Bool
    @FocusState var addressDetailFocusState: Bool
    
    @State private var showSuccessPopup = false
    @State private var showErrorPopup = false
    @State private var popupMessage = ""
    
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
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
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
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Detail Alamat")
                                .font(AppFont.Nunito.footnoteSmall)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            
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
                
                VStack {
                    Spacer()
                    
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
            .navigationTitle(isEditing ? "Ubah Alamat" : "Tambah Alamat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("brick"))
                }
            }
            .onAppear {
                if let detail = addressToEdit {
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
            }
            
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

struct FormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var isFirst: Bool = false
    var isLast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .font(AppFont.Raleway.bodyMedium)
                .keyboardType(keyboardType)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct FormTextArea: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isFirst: Bool = false
    var isLast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text, axis: .vertical)
                .font(AppFont.Raleway.bodyMedium)
                .lineLimit(2...4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
