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
    
    init(profileViewModel: ProfileViewModel, homeViewModel: HomeViewModel){
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                Header(profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Banner()
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Produk Kesenian")
                                    .font(AppFont.Raleway.titleMedium)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 15)
                                
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(homeViewModel.products) { product in
                                        NavigationLink(
                                            destination: ProductDetail(idProduct: product.id, homeViewModel: homeViewModel),
                                            label: {
                                                CardProduct(product: product, homeViewModel: homeViewModel)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 15)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Jasa Kesenian")
                                    .font(AppFont.Raleway.titleMedium)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 15)
                                
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(homeViewModel.services) { service in
                                        NavigationLink(
                                            destination: ServiceDetail(idService: service.id, homeViewModel: homeViewModel),
                                            label: {
                                                CardService(service: service)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 15)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
                .refreshable {
                    homeViewModel.fetchProducts(isLoad: false)
                    homeViewModel.fetchServices(isLoad: false)
                }
            }
            
            if homeViewModel.isLoading {
                Loading(opacity: 1)
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
}
