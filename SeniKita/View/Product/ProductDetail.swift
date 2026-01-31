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
        ZStack(alignment: .bottom) {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                
                if productViewModel.isLoading {
                    productDetailSkeleton
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            productImageCard
                            productInfoCard
                            shippingCard
                            reviewsCard
                            sellerCard
                            otherProductsSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 120)
                    }
                }
            }
            
            if !productViewModel.isLoading {
                actionBar
            }
            
            if isPopupVisible {
                BasePopup(isShowing: $isPopupVisible, message: popupMessage, onConfirm: {
                    isPopupVisible = false
                }, isSuccess: isSuccess)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            productViewModel.fetchProductById(idProduct: idProduct, isLoad: true)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [productViewModel.product?.thumbnail ?? "Produk ini menarik!"])
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
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            }
            
            Spacer()
            
            Text("Detail Produk")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    showShareSheet.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundColor(Color("primary"))
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                }
                
                NavigationLink(destination: CartView(viewModel: homeViewModel)) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.system(size: 14))
                            .foregroundColor(Color("primary"))
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        
                        if homeViewModel.totalCart > 0 {
                            Text("\(homeViewModel.totalCart)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color("brick"))
                                .clipShape(Circle())
                                .offset(x: 4, y: -4)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Product Image
    private var productImageCard: some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: productViewModel.product?.thumbnail ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: geometry.size.width, height: 280)
                .clipped()
        }
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
    
    private var productInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(
                Double(productViewModel.product?.price ?? 0)
                    .formatPrice()
            )
                .font(AppFont.Nunito.headerLarge)
                .foregroundColor(Color("primary"))
            
            // Name
            Text(productViewModel.product?.name ?? "")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            // Stats row
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Text("Terjual \(productViewModel.product?.sold ?? "0")")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
                
                Text("•")
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", productViewModel.product?.average_rating ?? 0))
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                    
                    Text("(\(productViewModel.product?.rating_count ?? 0) Rating)")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Stock & Category
            HStack(spacing: 16) {
                Label {
                    Text("Stok: \(productViewModel.product?.stock ?? 0)")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "cube.box")
                        .foregroundColor(Color("primary"))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(productViewModel.product?.category?.name ?? "")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color("primary"))
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            // Description
            Text(productViewModel.product?.desc?.stripHTML ?? "")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Shipping Card
    private var shippingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pengiriman")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("primary"))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dikirim dari")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    Text(productViewModel.product?.shop?.region ?? "")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Image(systemName: "truck.box.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("tertiary"))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Estimasi Ongkir")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    Text("Rp 26.000 - 30.000")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var reviewsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ulasan Pembeli")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            ProductReviews(ratings: productViewModel.product?.ratings)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var sellerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Profil Seniman")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                if let profilePicture = productViewModel.product?.shop?.profile_picture,
                   !profilePicture.isEmpty {
                    WebImage(url: URL(string: profilePicture))
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("primary").opacity(0.2), lineWidth: 2)
                        )
                } else {
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 56, height: 56)
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(productViewModel.product?.shop?.name ?? "")
                        .font(AppFont.Nunito.bodyLarge)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color("primary"))
                        Text(productViewModel.product?.shop?.region ?? "")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            Text(productViewModel.product?.shop?.desc ?? "Deskripsi toko belum tersedia.")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Other Products
    private var otherProductsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Produk Lainnya")
                .font(AppFont.Nunito.headerMedium)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(homeViewModel.products.filter { $0.id != idProduct }.prefix(10)) { product in
                        NavigationLink(
                            destination: ProductDetail(idProduct: product.id, homeViewModel: homeViewModel),
                            label: {
                                CardProduct(product: product, homeViewModel: homeViewModel)
                            }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Action Bar
    private var actionBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
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
                )) {
                    HStack(spacing: 8) {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 14))
                        Text("Beli Sekarang")
                            .font(AppFont.Nunito.bodyMedium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color("primary").opacity(0.3), radius: 8, y: 4)
                }
                
                Button {
                    homeViewModel.addProductToCart(productId: idProduct, isLoad: true) { success, message in
                        homeViewModel.showPopup(message: message, isSuccess: success)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 14))
                        Text("Keranjang")
                            .font(AppFont.Nunito.bodyMedium)
                    }
                    .foregroundColor(Color("primary"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("primary"), lineWidth: 2)
                    )
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 30)
            .background(Color.white)
        }
    }
    
    // MARK: - Skeleton
    private var productDetailSkeleton: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Image skeleton
                SkeletonLoading(width: .infinity, height: 280, cornerRadius: 20)
                
                // Info card skeleton
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonLoading(width: 140, height: 28)
                    SkeletonLoading(width: 200, height: 20)
                    SkeletonLoading(width: 180, height: 14)
                    Divider()
                    HStack {
                        SkeletonLoading(width: 100, height: 16)
                        Spacer()
                        SkeletonLoading(width: 80, height: 24, cornerRadius: 8)
                    }
                    Divider()
                    SkeletonLoading(width: .infinity, height: 60)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                
                // Shipping skeleton
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonLoading(width: 100, height: 18)
                    HStack(spacing: 12) {
                        SkeletonLoading(width: 20, height: 20, isCircle: true)
                        VStack(alignment: .leading, spacing: 4) {
                            SkeletonLoading(width: 80, height: 12)
                            SkeletonLoading(width: 120, height: 16)
                        }
                    }
                    Divider()
                    HStack(spacing: 12) {
                        SkeletonLoading(width: 20, height: 20, isCircle: true)
                        VStack(alignment: .leading, spacing: 4) {
                            SkeletonLoading(width: 100, height: 12)
                            SkeletonLoading(width: 140, height: 16)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                
                // Seller skeleton
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonLoading(width: 120, height: 18)
                    HStack(spacing: 12) {
                        SkeletonLoading(width: 56, height: 56, isCircle: true)
                        VStack(alignment: .leading, spacing: 6) {
                            SkeletonLoading(width: 140, height: 18)
                            SkeletonLoading(width: 100, height: 14)
                        }
                    }
                    SkeletonLoading(width: .infinity, height: 40)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
}
