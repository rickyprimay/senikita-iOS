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
    @StateObject private var paymentServiceViewModel = PaymentServiceViewModel()
    
    var imageService: String?
    var serviceId: Int
    var nameShop: String?
    var nameService: String?
    var price: Double?
    @State private var currentStep = 1
    @State private var showPopup = false
    @State private var popupMessage = ""
    @State private var navigateToHistory = false
    
    var body: some View {
        ZStack{
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
                        currentStep: $currentStep,
                        addressViewModel: addressViewModel,
                        paymentServiceViewModel: paymentServiceViewModel,
                        serviceId: serviceId
                    )
                    
                }
                .padding(.horizontal)
            }
            
            if paymentServiceViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            if showPopup {
                BasePopup(
                    isShowing: $showPopup,
                    message: popupMessage,
                    onConfirm: {
                        showPopup = false
                        navigateToHistory = true
                    },
                    isSuccess: true
                )
            }
            
            NavigationLink(destination: History(isFromPayment: true), isActive: $navigateToHistory) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(paymentServiceViewModel.$isCheckoutSuccess) { success in
            if success {
                popupMessage = "Pemesanan Berhasil, Lanjut ke Pembayaran?"
                showPopup = true
            }
        }
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
                Text("Pemesanan Jasa")
                    .font(AppFont.Crimson.bodyLarge)
                    .bold()
                    .foregroundColor(Color("tertiary"))
            }
        }
    }
    
}
