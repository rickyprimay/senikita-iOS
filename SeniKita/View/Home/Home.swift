//
//  Home.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var isPopupVisible = false
    @State private var popupMessage = ""
    @State private var isSuccess = false
    
    init(profileViewModel: ProfileViewModel, homeViewModel: HomeViewModel) {
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Header(profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Banner()
                            .padding(.top, 16)
                        
                        // Products Section
                        productSection
                        
                        // Services Section
                        serviceSection
                    }
                    .padding(.bottom, 100)
                }
                .refreshable {
                    homeViewModel.fetchProducts(isLoad: false)
                    homeViewModel.fetchServices(isLoad: false)
                }
            }
            
            if homeViewModel.isLoading {
                Loading(opacity: 0.8)
            }
            
            if isPopupVisible {
                BasePopup(isShowing: $isPopupVisible, message: popupMessage, onConfirm: {
                    isPopupVisible = false
                }, isSuccess: isSuccess)
            }
        }
        .navigationBarHidden(true)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowPopup"))) { notification in
            if let userInfo = notification.userInfo,
               let message = userInfo["message"] as? String,
               let success = userInfo["isSuccess"] as? Bool {
                self.popupMessage = message
                self.isSuccess = success
                self.isPopupVisible = true
            }
        }
    }
    
    private var productSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Produk Kesenian")
                        .font(AppFont.Nunito.headerMedium)
                        .foregroundColor(.primary)
                    
                    Text("Karya seni dari seniman lokal")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Product count badge
                Text("\(homeViewModel.products.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color("primary"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(homeViewModel.products) { product in
                        NavigationLink(
                            destination: ProductDetail(idProduct: product.id, homeViewModel: homeViewModel),
                            label: {
                                CardProduct(product: product, homeViewModel: homeViewModel)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var serviceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Jasa Kesenian")
                        .font(AppFont.Nunito.headerMedium)
                        .foregroundColor(.primary)
                    
                    Text("Layanan jasa dari seniman profesional")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Service count badge
                Text("\(homeViewModel.services.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color("tertiary"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(homeViewModel.services) { service in
                        NavigationLink(
                            destination: ServiceDetail(idService: service.id, homeViewModel: homeViewModel),
                            label: {
                                CardService(service: service)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}
