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
    @State private var isPopupVisible = false
    @State private var popupMessage = ""
    @State private var isSuccess = false
    
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
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            
                            Text("•")
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            
                            Text(String(format: "%.1f", productViewModel.product?.average_rating ?? 0))
                                .font(AppFont.Raleway.bodyMedium)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                            
                            Text("(\(productViewModel.product?.rating_count ?? 0) Rating)")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                        }
                        
                        Text("Stok: \(productViewModel.product?.stock ?? 0)")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        HStack {
                            Text("Kategori:")
                            Text(productViewModel.product?.category?.name ?? "")
                                .foregroundStyle(Color("primary"))
                                .fontWeight(.regular)
                        }
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        
                        Text(productViewModel.product?.desc?.stripHTML ?? "")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        
                        Text("Pengiriman")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .bold()
                        
                        HStack{
                            
                            Image(systemName: "mappin.and.ellipse")
                                .font(AppFont.Raleway.bodyMedium)
                            
                            Text("Dikirim dari")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                            
                            Text(productViewModel.product?.shop?.region ?? "")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                                .bold()
                            
                        }
                        
                        HStack{
                            
                            Image(systemName: "truck.box")
                                .font(AppFont.Raleway.bodyMedium)
                            
                            Text("Estimasi Ongkir")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                            
                            Text("Rp. 26.000 - 30.000")
                                .font(AppFont.Nunito.bodyMedium)
                                .foregroundColor(.black)
                            
                        }
                        
                        ProductReviews(ratings: productViewModel.product?.ratings)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Profil Seniman")
                                .font(AppFont.Raleway.bodyMedium)
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
                                        .font(AppFont.Raleway.bodyMedium)
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    Text(productViewModel.product?.shop?.region ?? "Wilayah Tidak Ada")
                                        .font(AppFont.Raleway.bodyMedium)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Text(productViewModel.product?.shop?.desc ?? "Deskripsi toko belum tersedia.")
                                .font(AppFont.Raleway.bodyMedium)
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
                                                CardProduct(product: product, homeViewModel: homeViewModel)
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
                .padding(.bottom, 80)
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
                    HStack(spacing: 6) {
                        
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
                        
                        NavigationLink(destination: CartView(viewModel: homeViewModel)) {
                            Image(systemName: "cart")
                                .font(AppFont.Crimson.bodyLarge)
                                .frame(width: 40, height: 40)
                                .background(Color.brown.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .tint(Color("tertiary"))
                        
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [productViewModel.product?.thumbnail ?? "Produk ini menarik!"])
            }
            if productViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            if isPopupVisible {
                BasePopup(isShowing: $isPopupVisible, message: popupMessage, onConfirm: {
                    isPopupVisible = false
                }, isSuccess: isSuccess)
            }
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        NavigationLink(destination: Payment(
                            storeAvatar: productViewModel.product?.shop?.profile_picture ?? "",
                            storeName: productViewModel.product?.shop?.name ?? "",
                            storeLocation: productViewModel.product?.shop?.region ?? "",
                            productId: idProduct,
                            productImage: productViewModel.product?.thumbnail ?? "",
                            productName: productViewModel.product?.name ?? "",
                            productPrice: productViewModel.product?.price ?? 0,
                            productQty: 1,
                            originId: productViewModel.product?.shop?.city?.id ?? 0
                        )){
                            Text("Beli Sekarang")
                                .font(AppFont.Nunito.bodyMedium)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 120)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color("primary"))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            homeViewModel.addProductToCart(productId: idProduct, isLoad: true) { success, message in
                                homeViewModel.showPopup(message: message, isSuccess: success)
                            }
                        } label: {
                            Text("Keranjang")
                                .font(AppFont.Nunito.bodyMedium)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 120)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding(.bottom, 25)
                .background(Color.clear)
            }
            .ignoresSafeArea(edges: .bottom)
            
        }
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


