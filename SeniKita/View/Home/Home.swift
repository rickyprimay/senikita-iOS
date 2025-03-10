//
//  Home.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

struct Home: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                Header()
                
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
                                                CardProduct(product: product)
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
        }
        .navigationBarHidden(true)
    }
}
