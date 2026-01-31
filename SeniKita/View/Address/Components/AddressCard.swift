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
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(address.label_address)
                            .font(AppFont.Nunito.footnoteSmall)
                            .foregroundColor(Color("brick"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color("brick").opacity(0.12))
                            .cornerRadius(12)
                        
                        Spacer()
                    }
                    
                    Text(address.name)
                        .font(AppFont.Nunito.subtitle)
                        .foregroundColor(.primary)
                    
                    Text(address.phone)
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button {
                        addressViewModel.getAddressById(idAddress: address.id)
                        addressToEdit = address
                        isEditing = true
                        showSheetAddAddress = true
                    } label: {
                        Label("Ubah", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Hapus", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(address.address_detail)
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                if let note = address.note, !note.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "note.text")
                            .font(.system(size: 11))
                        Text(note)
                            .font(AppFont.Raleway.footnoteSmall)
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
