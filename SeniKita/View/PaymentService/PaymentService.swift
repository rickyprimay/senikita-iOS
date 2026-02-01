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
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Header
                navigationHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header Section
                        headerSection
                        
                        // Step Indicator
                        stepIndicator
                        
                        // Form Content
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
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
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(paymentServiceViewModel.$isCheckoutSuccess) { success in
            if success {
                popupMessage = "Pemesanan Berhasil, Lanjut ke Pembayaran?"
                showPopup = true
            }
        }
        .hideTabBar()
    }
    
    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("primary"))
                    .frame(width: 40, height: 40)
                    .background(Color("primary").opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Pemesanan Jasa")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(Color("tertiary"))
            
            Spacer()
            
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Pesan Layanan Kesenian")
                .font(AppFont.Nunito.titleMedium)
                .bold()
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Isi detail pesanan Anda sesuai langkah-langkah berikut.")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Step Indicator
    private var stepIndicator: some View {
        HStack(alignment: .top, spacing: 0) {
            StepView(stepNumber: "1", title: "Informasi\nKegiatan", isActive: currentStep >= 1)
            
            stepLine(isActive: currentStep >= 2)
            
            StepView(stepNumber: "2", title: "Permintaan\nKhusus", isActive: currentStep >= 2)
            
            stepLine(isActive: currentStep >= 3)
            
            StepView(stepNumber: "3", title: "Persetujuan\n& Konfirmasi", isActive: currentStep >= 3)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func stepLine(isActive: Bool) -> some View {
        Rectangle()
            .fill(isActive ? Color("tertiary").opacity(0.5) : Color.gray.opacity(0.3))
            .frame(height: 2)
            .frame(maxWidth: 20)
            .padding(.top, 14)
    }
}
