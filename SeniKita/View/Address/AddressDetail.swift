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
    
    @State private var showSheetAddAddress: Bool = false
    @State private var isShowingDeleteAlert = false
    @State private var addressToDelete: Address?
    @State private var isEditing: Bool = false
    @State private var addressToEdit: Address?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Daftar Alamat")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        showSheetAddAddress.toggle()
                        isEditing = false
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Tambah Alamat")
                        }
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(Color("primary"))
                        .cornerRadius(8)
                    }
                }
                
                ScrollView {
                    if addressViewModel.address.isEmpty {
                        Text("Anda belum mempunyai alamat")
                            .font(AppFont.Raleway.bodyLarge)
                            .foregroundColor(Color("primary"))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(addressViewModel.address, id: \.id) { address in
                            AddressCard(
                                addressViewModel: addressViewModel,
                                address: address,
                                onDelete: {
                                    addressToDelete = address
                                    isShowingDeleteAlert = true
                                },
                                isEditing: $isEditing,
                                addressToEdit: $addressToEdit,
                                showSheetAddAddress: $showSheetAddAddress
                            )

                        }
                    }
                }
                .sheet(isPresented: $showSheetAddAddress) {
                    AddAddressSheet(addressViewModel: addressViewModel, isEditing: $isEditing, addressToEdit: $addressToEdit)
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
                                .font(AppFont.Raleway.bodyLarge)
                                .frame(width: 40, height: 40)
                                .background(Color.brown.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .tint(Color("tertiary"))
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Alamat")
                            .font(AppFont.Raleway.bodyLarge)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                }
            }
            .padding(.horizontal)
            if addressViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            if isShowingDeleteAlert {
                DeleteAddressAlert(isShowing: $isShowingDeleteAlert) {
                    if let address = addressToDelete {
                        addressViewModel.deleteAddress(idAddress: address.id) { success, message in
                            if success {
                                print("Sukses: \(message)")
                            } else {
                                print("Gagal: \(message)")
                            }
                        }
                    }
                }
            }

        }
        .hideTabBar()
    }
}
