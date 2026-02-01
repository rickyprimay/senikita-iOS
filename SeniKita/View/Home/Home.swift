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
                            .padding(.top, 60)
                        
                        if !homeViewModel.searchText.isEmpty && homeViewModel.displayProducts.isEmpty && homeViewModel.displayServices.isEmpty && !homeViewModel.isLoading && !homeViewModel.isSearching {
                            searchEmptyState
                        } else {
                            productSection
                            serviceSection
                        }
                    }
                    .padding(.bottom, 100)
                }
                .refreshable {
                    homeViewModel.fetchProducts(isLoad: false)
                    homeViewModel.fetchServices(isLoad: false)
                    homeViewModel.fetchCart()
                }

            }
            .ignoresSafeArea(edges: .top)
            
            if isPopupVisible {
                BasePopup(isShowing: $isPopupVisible, message: popupMessage, onConfirm: {
                    isPopupVisible = false
                }, isSuccess: isSuccess)
            }
        }

        .toolbar(.hidden, for: .navigationBar)
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
    
    private var searchEmptyState: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 40)
            
            ZStack {
                Circle()
                    .fill(Color("primary").opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundColor(Color("primary"))
            }
            
            VStack(spacing: 4) {
                Text("Tidak Ditemukan")
                    .font(AppFont.Nunito.bodyLarge)
                    .foregroundColor(.primary)
                
                Text("Coba kata kunci lain untuk \"\(homeViewModel.searchText)\"")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
                .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
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
                
                if !homeViewModel.isLoading {
                    Text("\(homeViewModel.displayProducts.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color("primary"))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            
            if homeViewModel.isLoading || homeViewModel.isSearching {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { _ in
                            ProductCardSkeleton()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else if homeViewModel.displayProducts.isEmpty {
                sectionEmptyState(icon: "cube.box", text: "Tidak ada produk ditemukan")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(homeViewModel.displayProducts) { product in
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
                
                if !homeViewModel.isLoading {
                    Text("\(homeViewModel.displayServices.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color("tertiary"))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            
            if homeViewModel.isLoading || homeViewModel.isSearching {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { _ in
                            ServiceCardSkeleton()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else if homeViewModel.displayServices.isEmpty {
                sectionEmptyState(icon: "paintbrush.pointed", text: "Tidak ada jasa ditemukan")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(homeViewModel.displayServices) { service in
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
    
    private func sectionEmptyState(icon: String, text: String) -> some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(UIColor.systemGray3))
                Text(text)
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 32)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
