//
//  PaymentService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 03/05/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PaymentService: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var addressViewModel = AddressViewModel()
    
    var imageService: String?
    var nameShop: String?
    var nameService: String?
    var price: Double?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Text("Pesan Layanan Kesenian")
                    .font(AppFont.Raleway.titleMedium)
                    .foregroundColor(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Isi detail pesanan Anda sesuai langkah-langkah berikut.")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                HStack {
                    Text("Nama Layanan Kesenian")
                        .font(AppFont.Raleway.bodyLarge)
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Informasi")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color("tertiary"))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Kegiatan/Acara")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.clear)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Permintaan Khusus")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.clear)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Persetujuan dan Konfirmasi")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                InformationEvent(
                    imageService: imageService,
                    nameShop: nameShop,
                    nameService: nameService,
                    price: price
                )
                
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(AppFont.Crimson.bodyLarge)
                        .frame(width: 40, height: 40)
                        .background(Color.brown.opacity(0.3))
                        .clipShape(Circle())
                }
                .tint(Color("tertiary"))
            }
            ToolbarItem(placement: .principal) {
                Text("Pembayaran Jasa")
                    .font(AppFont.Crimson.bodyLarge)
                    .bold()
                    .foregroundColor(Color("tertiary"))
            }
        }
    }
    
}
