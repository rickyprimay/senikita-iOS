//
//  ProductDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var productViewModel = ProductViewModel()
    @ObservedObject var homeViewModel: HomeViewModel
    
    @State private var showShareSheet = false
    
    var idProduct: Int
    
    init(idProduct: Int, homeViewModel: HomeViewModel) {
        self.idProduct = idProduct
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack() {
                    
                    ZStack(alignment: .topTrailing) {
                        WebImage(url: URL(string: productViewModel.product?.thumbnail ?? ""))
                            .resizable()
                            .indicator(.activity)
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Button(action: {
                            
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding(.trailing, 20)
                        .padding(.top)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rp\(productViewModel.product?.price ?? 0)")
                            .font(AppFont.Raleway.titleMedium)
                            .foregroundColor(Color("primary"))
                            .lineLimit(1)
                        
                        Text(productViewModel.product?.name ?? "")
                            .font(AppFont.Crimson.titleMedium)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        HStack(spacing: 4) {
                            Text("Terjual \(productViewModel.product?.sold ?? 0)")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            
                            Text("•")
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            
                            Text(String(format: "%.1f", productViewModel.product?.average_rating ?? 0))
                                .font(AppFont.Nunito.bodyMedium)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("(\(productViewModel.product?.rating_count ?? 0) Rating)")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                        }
                        
                        Text("Stok: \(productViewModel.product?.stock ?? 0)")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        HStack {
                            Text("Kategori:")
                            Text(productViewModel.product?.category?.name ?? "")
                                .foregroundStyle(Color("primary"))
                                .fontWeight(.bold)
                        }
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        
                        Text(productViewModel.product?.desc?.stripHTML ?? "")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        
                        Text("Pengiriman")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.black)
                            .bold()
                        
                        HStack{
                            
                            Image(systemName: "mappin.and.ellipse")
                                .font(AppFont.Nunito.bodyMedium)
                            
                            Text("Dikirim dari")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                            
                            Text(productViewModel.product?.shop?.region ?? "")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                                .bold()
                            
                        }
                        
                        HStack{
                            
                            Image(systemName: "truck.box")
                                .font(AppFont.Nunito.bodyMedium)
                            
                            Text("Estimasi Ongkir")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                            
                            Text("Rp. 26.000 - 30.000")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                            
                        }
                        
                        ProductReviews(ratings: productViewModel.product?.ratings)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Profil Seniman")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                                .bold()
                            
                            HStack(alignment: .center, spacing: 12) {
                                if let profilePicture = productViewModel.product?.shop?.profile_picture,
                                   !profilePicture.isEmpty {
                                    WebImage(url: URL(string: profilePicture))
                                        .resizable()
                                        .indicator(.activity)
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(productViewModel.product?.shop?.name ?? "Nama Toko Tidak Ada")
                                        .font(AppFont.Nunito.bodyMedium)
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    Text(productViewModel.product?.shop?.region ?? "Wilayah Tidak Ada")
                                        .font(AppFont.Nunito.bodyMedium)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Text(productViewModel.product?.shop?.desc ?? "Deskripsi toko belum tersedia.")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.top)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Produk Lainnya")
                                    .font(AppFont.Raleway.titleMedium)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                            }
                            .padding(.vertical)
                            
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
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                }
                .padding(.horizontal)
            }
            .onAppear{
                productViewModel.fetchProductById(idProduct: idProduct, isLoad: true)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(AppFont.Crimson.bodyLarge)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .tint(Color("tertiary"))
                }
                ToolbarItem(placement: .principal) {
                    Text("Detail Produk")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("tertiary"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showShareSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(AppFont.Crimson.bodyLarge)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .tint(Color("tertiary"))
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [productViewModel.product?.thumbnail ?? "Produk ini menarik!"])
            }
            if productViewModel.isLoading {
                Loading(opacity: 0.5)
            }
        }
    }
}

extension String {
    var stripHTML: String {
        let withoutHTML = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        let withoutNbsp = withoutHTML.replacingOccurrences(of: "&nbsp;", with: " ")
        return withoutNbsp
    }
}
