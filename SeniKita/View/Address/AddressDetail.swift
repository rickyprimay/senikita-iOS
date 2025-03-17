//
//  AddressDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/03/25.
//

import SwiftUI

struct AddressDetail: View {
    
    @StateObject var addressViewModel = AddressViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State var showSheetAddAddress: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Daftar Alamat")
                        .font(AppFont.Nunito.bodyLarge)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        showSheetAddAddress.toggle()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Tambah Alamat")
                        }
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(Color("primary"))
                        .cornerRadius(8)
                    }
                }
                
                ScrollView {
                    if addressViewModel.address.isEmpty {
                        Text("Anda belum mempunyai alamat")
                            .font(AppFont.Nunito.bodyLarge)
                            .foregroundColor(Color("primary"))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(addressViewModel.address, id: \.id) { address in
                            AddressCard(address: address)
                        }
                    }
                }
                .sheet(isPresented: $showSheetAddAddress) {
                    print("Sheet Dissmissed!")
                } content: {
                    AddAddressSheet(addressViewModel: addressViewModel)
                }
                .refreshable {
                    addressViewModel.getAddress()
                }
                .onAppear {
                    addressViewModel.getAddress()
                    addressViewModel.getProvinces()
                }
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(AppFont.Nunito.bodyLarge)
                                .frame(width: 40, height: 40)
                                .background(Color.brown.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .tint(Color("tertiary"))
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Alamat")
                            .font(AppFont.Nunito.bodyLarge)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                }
            }
            .padding(.horizontal)
            if addressViewModel.isLoading {
                Loading(opacity: 0.5)
            }
        }
    }
}

struct AddressCard: View {
    var address: Address
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(address.label_address)
                .font(AppFont.Nunito.bodyMedium)
                .bold()
                .foregroundStyle(Color("primary"))
                .padding(4)
                .background(Color("tertiary").opacity(0.5))
                .cornerRadius(12)
            
            Text(address.name)
                .font(AppFont.Nunito.bodyMedium)
                .bold()
            
            Text(address.phone)
                .font(AppFont.Nunito.bodyMedium)
            
            Text(address.address_detail)
                .font(AppFont.Nunito.bodyMedium)
            
            Text(address.note ?? "")
                .font(AppFont.Nunito.bodyMedium)
                .foregroundColor(.gray)
            
            HStack {
                Button(action: {
                    
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.pencil")
                        Text("Ubah Alamat")
                    }
                    .font(AppFont.Nunito.bodyMedium)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                }
                
                Button(action: {
                    
                }) {
                    
                    HStack {
                        Image(systemName: "trash")
                        Text("Hapus")
                    }
                    .font(AppFont.Nunito.bodyMedium)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                }
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}

struct AddAddressSheet: View {
    
    @ObservedObject var addressViewModel: AddressViewModel
    
    @State private var labelAddress: String = ""
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var addressDetail: String = ""
    @State private var selectedProvince: Province? = nil
    @State private var selectedCity: City? = nil
    
    @FocusState var labelFocusState: Bool
    @FocusState var nameFocusState: Bool
    @FocusState var phoneFocusState: Bool
    @FocusState var addressDetailFocusState: Bool
    
    var body: some View {
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
                            print(provinceId)
                            addressViewModel.getCitiesByIdProvinces(idProvinces: provinceId)
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
                }
                .padding(.horizontal)
            }
            
            Button(action: {}) {
                Text("Simpan")
                    .font(AppFont.Nunito.bodyMedium)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primary"))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .padding(.vertical)
        .background(Color.white.ignoresSafeArea())
    }
}

struct CustomPicker<T: Identifiable & Hashable>: View {
    var label: String
    @Binding var selection: T?
    var options: [T]
    var displayProperty: KeyPath<T, String>
    
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFont.Crimson.footnoteLarge)
                .bold()
            
            Button(action: {
                isPickerPresented = true
            }) {
                HStack {
                    Text(selection?[keyPath: displayProperty] ?? "Pilih \(label)")
                        .foregroundColor(selection == nil ? .gray : .black)
                        .font(AppFont.Crimson.footnoteLarge)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .sheet(isPresented: $isPickerPresented) {
                NavigationView {
                    PickerListView(title: label, options: options, displayProperty: displayProperty, selection: $selection)
                }
            }
        }
    }
}

#Preview {
    AddressDetail()
}
