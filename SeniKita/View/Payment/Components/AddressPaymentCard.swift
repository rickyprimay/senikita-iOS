//
//  AddressPaymentCard.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 25/03/25.
//

import SwiftUI

struct AddressPaymentCard: View {
    
    var address: Address?
    
    var body: some View {
        Text(address?.label_address ?? "")
            .font(AppFont.Nunito.bodyMedium)
            .bold()
            .foregroundStyle(Color("primary"))
            .padding(4)
            .background(Color("tertiary").opacity(0.3))
            .cornerRadius(12)
        
        Text(address?.name ?? "")
            .font(AppFont.Nunito.bodyMedium)
            .bold()
        
        Text(address?.phone ?? "")
            .font(AppFont.Nunito.bodyMedium)
        
        Text(address?.address_detail ?? "")
            .font(AppFont.Nunito.bodyMedium)
        
        Text(address?.note ?? "")
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
                        .stroke(
                            Color.gray.opacity(0.4),
                            lineWidth: 1)
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
                        .stroke(
                            Color.gray.opacity(0.4),
                            lineWidth: 1)
                )
            }
            
            Spacer()
        }
        .padding(.top, 8)
    }
}
