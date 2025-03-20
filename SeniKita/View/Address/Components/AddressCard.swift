//
//  AddressCard.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 18/03/25.
//

import SwiftUI

struct AddressCard: View {
    
    @ObservedObject var addressViewModel: AddressViewModel
    var address: Address
    var onDelete: () -> Void
    @Binding var isEditing: Bool
    
    @Binding var addressToEdit: Address?
    @Binding var showSheetAddAddress: Bool
    
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
                    addressViewModel.getAddressById(idAddress: address.id)
                    addressToEdit = address
                    isEditing = true
                    showSheetAddAddress = true
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
                    onDelete()
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
