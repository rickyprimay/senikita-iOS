//
//  Home.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var productScrollID: Int? = nil
    @State private var serviceScrollID: Int? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                Header()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        // Produk Kesenian
                        HStack {
                            Text("Produk Kesenian")
                                .font(AppFont.Raleway.titleMedium)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                            
                            HStack(spacing: 15) {
                                Button {
                                    // Geser ke kiri
                                    withAnimation {
                                        if let firstProductID = homeViewModel.products.first?.id {
                                            productScrollID = firstProductID
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.left")
                                        .font(AppFont.Raleway.titleMedium)
                                        .foregroundStyle(.white)
                                        .padding(12)
                                        .background(Color("brick"))
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                                
                                Button {
                                    // Geser ke kanan
                                    withAnimation {
                                        if let lastProductID = homeViewModel.products.last?.id {
                                            productScrollID = lastProductID
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.right")
                                        .font(AppFont.Raleway.titleMedium)
                                        .foregroundStyle(.white)
                                        .padding(12)
                                        .background(Color("brick"))
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(homeViewModel.products) { product in
                                        CardProduct(product: product)
                                            .id(product.id) // Memberikan ID unik untuk setiap produk
                                    }
                                }
                                .padding(.horizontal, 15)
                            }
                            .onChange(of: productScrollID) { newID in
                                withAnimation {
                                    proxy.scrollTo(newID, anchor: .center) // Geser ke ID yang dipilih
                                }
                            }
                        }
                    }
                    
                    // Jasa Kesenian
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Jasa Kesenian")
                                .font(AppFont.Raleway.titleMedium)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                            
                            HStack(spacing: 15) {
                                Button {
                                    // Geser ke kiri
                                    withAnimation {
                                        if let firstServiceID = homeViewModel.services.first?.id {
                                            serviceScrollID = firstServiceID
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.left")
                                        .font(AppFont.Raleway.titleMedium)
                                        .foregroundStyle(.white)
                                        .padding(12)
                                        .background(Color("brick"))
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                                
                                Button {
                                    // Geser ke kanan
                                    withAnimation {
                                        if let lastServiceID = homeViewModel.services.last?.id {
                                            serviceScrollID = lastServiceID
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.right")
                                        .font(AppFont.Raleway.titleMedium)
                                        .foregroundStyle(.white)
                                        .padding(12)
                                        .background(Color("brick"))
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(homeViewModel.services) { service in
                                        CardService(service: service)
                                            .id(service.id) // Memberikan ID unik untuk setiap jasa
                                    }
                                }
                                .padding(.horizontal, 15)
                            }
                            .onChange(of: serviceScrollID) { newID in
                                withAnimation {
                                    proxy.scrollTo(newID, anchor: .center) // Geser ke ID yang dipilih
                                }
                            }
                        }
                    }
                }
            }
            
            if homeViewModel.isLoading {
                Loading()
            }
        }
    }
}

#Preview {
    Home()
}
