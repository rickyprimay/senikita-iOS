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
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tambah Alamat Baru")
                        .font(AppFont.Nunito.bodyLarge)
                        .bold()
                        .padding(.horizontal)
                    
                    Text("Masukkan alamat lengkap baru")
                        .font(AppFont.Nunito.subtitle)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                    
                    DividerLabel(label: "Tambah Alamat")
                        .padding(.vertical)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CustomTextField(
                            label: "Label Alamat",
                            text: $labelAddress,
                            placeholder: "Contoh: Rumah, Kantor, dll.",
                            isSecure: false,
                            fontType: .crimson,
                            nextFocus: $nameFocusState,
                            isLast: false
                        )
                        
                        CustomTextField(
                            label: "Nama Penerima/Penanggung Jawab",
                            text: $name,
                            placeholder: "Masukan nama",
                            isSecure: false,
                            fontType: .crimson,
                            nextFocus: $phoneFocusState,
                            isLast: false
                        )
                        .focused($nameFocusState)
                        
                        CustomTextField(
                            label: "Telepon",
                            text: $phone,
                            placeholder: "Masukkan nomor telepon",
                            isSecure: false,
                            keyboardType: .phonePad,
                            fontType: .crimson,
                            nextFocus: $addressDetailFocusState,
                            isLast: false
                        )
                        .focused($phoneFocusState)
                        
                        CustomTextField(
                            label: "Kode Pos",
                            text: $postalCode,
                            placeholder: "Masukkan kode pos",
                            isSecure: false,
                            keyboardType: .phonePad,
                            fontType: .crimson,
                            isLast: false
                        )
                        
                        CustomTextField(
                            label: "Alamat",
                            text: $addressDetail,
                            placeholder: "Masukan alamat lengkap",
                            isSecure: false,
                            fontType: .crimson,
                            isLast: false
                        )
                        .focused($addressDetailFocusState)
                        
                        CustomPicker(
                            label: "Provinsi",
                            selection: $selectedProvince,
                            options: addressViewModel.province,
                            displayProperty: \.name
                        )
                        .onChange(of: selectedProvince) {
                            if let provinceId = selectedProvince?.id {
                                
                                addressViewModel.getCitiesByIdProvinces(idProvinces: provinceId){
                                    
                                }
                            }
                            selectedCity = nil
                        }
                        
                        CustomPicker(
                            label: "Kabupaten/Kota",
                            selection: $selectedCity,
                            options: addressViewModel.cityByProvince,
                            displayProperty: \.name
                        )
                        .disabled(selectedProvince == nil)
                        .opacity(selectedProvince == nil ? 0.5 : 1)
                        
                        CustomTextField(
                            label: "Catatan",
                            text: $note,
                            placeholder: "Berikan catatan",
                            isSecure: false,
                            fontType: .crimson,
                            isLast: true
                        )
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
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
                            popupMessage = message
                            if success {
                                showSuccessPopup = true
                            } else {
                                showErrorPopup = true
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
                            popupMessage = message
                            if success {
                                showSuccessPopup = true
                            } else {
                                showErrorPopup = true
                            }
                        }
                    }
                }) {
                    Text(isEditing ? "Ubah" : "Simpan")
                        .font(AppFont.Nunito.bodyMedium)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color("primary") : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.top)
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
            .padding(.vertical)
            .background(Color.white.ignoresSafeArea())
            if showErrorPopup || showSuccessPopup {
                BasePopup(isShowing: showErrorPopup ? $showErrorPopup : $showSuccessPopup,
                          message: popupMessage,
                          onConfirm: {
                    if showSuccessPopup {
                        showSuccessPopup = false
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showErrorPopup = false
                    }
                },
                          isSuccess: showSuccessPopup)
            }
            
            if addressViewModel.isLoading {
                Loading(opacity: 0.5)
            }
        }
    }
}
