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
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if addressViewModel.address.isEmpty && !addressViewModel.isLoading {
                    emptyStateView
                } else {
                    addressListView
                }
            }
            
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
        .sheet(isPresented: $showSheetAddAddress) {
            AddAddressSheet(addressViewModel: addressViewModel, isEditing: $isEditing, addressToEdit: $addressToEdit)
        }
        .onAppear {
            addressViewModel.getAddress()
            addressViewModel.getProvinces()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("brick"))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Alamat Saya")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSheetAddAddress.toggle()
                    isEditing = false
                    addressToEdit = nil
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("brick"))
                }
            }
        }
        .hideTabBar()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "mappin.slash")
                .font(.system(size: 60))
                .foregroundColor(Color.gray.opacity(0.4))
            
            VStack(spacing: 8) {
                Text("Belum Ada Alamat")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
                
                Text("Tambahkan alamat pengiriman untuk\nmemudahkan proses pembelian")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                showSheetAddAddress.toggle()
                isEditing = false
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Tambah Alamat")
                }
                .font(AppFont.Nunito.bodyMedium)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color("brick"))
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var addressListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
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
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .refreshable {
            addressViewModel.getAddress()
        }
    }
}
