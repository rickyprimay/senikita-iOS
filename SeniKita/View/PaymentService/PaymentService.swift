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
    @State private var currentStep = 1
    
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
                
                HStack(spacing: 0) {
                    StepView(stepNumber: "1", title: "Informasi\nKegiatan/Acara", isActive: currentStep >= 1)
                    LineView()
                    StepView(stepNumber: "2", title: "Permintaan Khusus", isActive: currentStep >= 2)
                    LineView()
                    StepView(stepNumber: "3", title: "Persetujuan dan\nKonfirmasi", isActive: currentStep >= 3)
                }
                .padding(.vertical, 8)
                
                InformationEvent(
                    imageService: imageService,
                    nameShop: nameShop,
                    nameService: nameService,
                    price: price,
                    currentStep: $currentStep
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
