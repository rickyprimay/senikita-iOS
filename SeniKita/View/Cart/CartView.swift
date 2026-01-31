//
//  CartView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 19/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var selectedShops: [String: Bool] = [:]
    @State private var selectedProducts: [Int: Bool] = [:]
    
    var groupedProducts: [String: [Cart]] {
        Dictionary(grouping: viewModel.cart, by: { $0.storeName })
    }
    
    var totalHarga: Double {
        viewModel.cart.filter { selectedProducts[$0.cart_item_id] == true }
                    .reduce(0) { $0 + ($1.productPrice * Double($1.qty)) }
    }
    
    var selectedProductCount: Int {
        selectedProducts.filter { $0.value == true }.count
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                
                if viewModel.isLoading && viewModel.cart.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            cartSummarySkeleton
                            
                            ForEach(0..<2, id: \.self) { _ in
                                shopCardSkeleton
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 120)
                    }
                } else if viewModel.cart.isEmpty {
                    emptyStateView
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            cartSummaryCard
                            
                            ForEach(groupedProducts.keys.sorted(), id: \.self) { shopName in
                                if let products = groupedProducts[shopName], let firstProduct = products.first {
                                    shopCard(shopName: shopName, products: products, firstProduct: firstProduct)
                                }
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 120)
                    }
                    .refreshable {
                        viewModel.getCartProduct(isLoad: true)
                    }
                }
            }
            
            if !viewModel.cart.isEmpty {
                checkoutBar
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.getCartProduct(isLoad: true)
            for shopName in groupedProducts.keys {
                selectedShops[shopName] = false
            }
            for product in viewModel.cart {
                selectedProducts[product.cart_item_id] = false
            }
        }
        .hideTabBar()
    }
    
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
            
            Text("Keranjang")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Badge for cart count
            ZStack {
                Circle()
                    .fill(Color("primary"))
                    .frame(width: 28, height: 28)
                
                Text("\(viewModel.cart.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var cartSummaryCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary").opacity(0.2), Color("tertiary").opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "cart.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.cart.count) item di keranjang")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                
                Text("Pilih produk untuk checkout")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func shopCard(shopName: String, products: [Cart], firstProduct: Cart) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Shop header
            HStack(spacing: 12) {
                Button(action: {
                    selectedShops[shopName]?.toggle()
                    let isSelected = selectedShops[shopName] ?? false
                    for product in products {
                        selectedProducts[product.cart_item_id] = isSelected
                    }
                }) {
                    Image(systemName: selectedShops[shopName] == true ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(selectedShops[shopName] == true ? Color("primary") : Color(UIColor.systemGray3))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(shopName)
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color("primary"))
                        
                        Text(firstProduct.storeLocation)
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color(UIColor.systemGray6))
            
            // Products
            VStack(spacing: 0) {
                ForEach(products, id: \.cart_item_id) { product in
                    CartProductCard(
                        product: product,
                        isSelected: Binding(
                            get: { selectedProducts[product.cart_item_id] ?? false },
                            set: { selectedProducts[product.cart_item_id] = $0 }
                        ),
                        viewModel: viewModel
                    )
                    
                    if product.cart_item_id != products.last?.cart_item_id {
                        Divider()
                            .padding(.leading, 52)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var checkoutBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Total Belanja")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(totalHarga.formatPrice())
                        .font(AppFont.Nunito.headerMedium)
                        .foregroundColor(Color("primary"))
                }
                
                Button(action: {
                    // Checkout action
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 16))
                        
                        Text("Beli (\(selectedProductCount))")
                            .font(AppFont.Nunito.bodyLarge)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Group {
                            if selectedProductCount > 0 {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                        }
                    )
                    .cornerRadius(12)
                    .shadow(color: selectedProductCount > 0 ? Color("primary").opacity(0.3) : Color.clear, radius: 8, y: 4)
                }
                .disabled(selectedProductCount == 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 30)
            .background(Color.white)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color("primary").opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "cart")
                    .font(.system(size: 44))
                    .foregroundColor(Color("primary"))
            }
            
            VStack(spacing: 8) {
                Text("Keranjang Kosong")
                    .font(AppFont.Nunito.bodyLarge)
                    .foregroundColor(.primary)
                
                Text("Belum ada produk di keranjang Anda")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
    
    private var cartSummarySkeleton: some View {
        HStack(spacing: 16) {
            SkeletonLoading(width: 50, height: 50, isCircle: true)
            VStack(alignment: .leading, spacing: 8) {
                SkeletonLoading(width: 140, height: 16)
                SkeletonLoading(width: 100, height: 12)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var shopCardSkeleton: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                SkeletonLoading(width: 24, height: 24, isCircle: true)
                VStack(alignment: .leading, spacing: 4) {
                    SkeletonLoading(width: 120, height: 16)
                    SkeletonLoading(width: 80, height: 12)
                }
                Spacer()
            }
            .padding(16)
            .background(Color(UIColor.systemGray6))
            
            VStack(spacing: 0) {
                ForEach(0..<2, id: \.self) { _ in
                    CartItemSkeleton()
                    Divider().padding(.leading, 52)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct CartProductCard: View {
    let product: Cart
    @Binding var isSelected: Bool
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                isSelected.toggle()
            }) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Color("primary") : Color(UIColor.systemGray3))
            }
            .padding(.top, 8)
            
            WebImage(url: URL(string: product.productThumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(12)
                .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.productName)
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text((product.productPrice * Double(product.qty)).formatPrice())
                    .font(AppFont.Nunito.bodyLarge)
                    .foregroundColor(Color("primary"))
                
                // Quantity controls
                HStack(spacing: 0) {
                    Button(action: {
                        if product.qty > 1 {
                            viewModel.decrementQuantity(cartItemId: product.cart_item_id)
                        } else if product.qty == 1 {
                            viewModel.deleteCartByIdItem(cartItemId: product.cart_item_id)
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(product.qty > 1 ? Color("primary") : .gray)
                            .frame(width: 28, height: 28)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    Text("\(product.qty)")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                        .frame(width: 40)
                    
                    Button(action: {
                        viewModel.incrementQuantity(cartItemId: product.cart_item_id)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color("primary"))
                            .frame(width: 28, height: 28)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.deleteCartByIdItem(cartItemId: product.cart_item_id)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.red.opacity(0.8))
                    .frame(width: 36, height: 36)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(16)
    }
}
