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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(viewModel.cart.count) item di keranjang Anda")
                        .font(AppFont.Crimson.titleMedium)
                        .padding(.horizontal)
                    
                    ForEach(groupedProducts.keys.sorted(), id: \.self) { shopName in
                        if let products = groupedProducts[shopName], let firstProduct = products.first {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Button(action: {
                                        selectedShops[shopName]?.toggle()
                                        let isSelected = selectedShops[shopName] ?? false
                                        for product in products {
                                            selectedProducts[product.cart_item_id] = isSelected
                                        }
                                    }) {
                                        Image(systemName: selectedShops[shopName] == true ? "checkmark.square.fill" : "square")
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedShops[shopName] == true ? Color("tertiary") : .gray)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(shopName)
                                            .font(AppFont.Nunito.bodyMedium)
                                        
                                        Text(firstProduct.storeLocation)
                                            .font(AppFont.Nunito.footnoteLarge)
                                    }
                                }
                                .padding(.horizontal)
                                
                                ForEach(products, id: \.cart_item_id) { product in
                                    CartProductView(product: product, isSelected: Binding(
                                        get: { selectedProducts[product.cart_item_id] ?? false },
                                        set: { selectedProducts[product.cart_item_id] = $0 }
                                    ), viewModel: viewModel)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 120)
            }
            .refreshable{
                viewModel.getCartProduct(isLoad: true)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .tint(Color("tertiary"))
                }
                ToolbarItem(placement: .principal) {
                    Text("Keranjang Anda(\(viewModel.cart.count))")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("tertiary"))
                }
            }
            
            if viewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Total Belanja")
                            .font(AppFont.Nunito.bodyMedium)
                            .bold()
                        
                        Spacer()
                        
                        Text("Rp\(totalHarga, specifier: "%.2f")")
                            .font(AppFont.Crimson.titleMedium)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    Button(action: {
                       
                    }) {
                        Text("Beli (\(selectedProductCount))")
                            .font(AppFont.Crimson.bodyMedium)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primary"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 25)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            viewModel.getCartProduct(isLoad: true)
            for shopName in groupedProducts.keys {
                selectedShops[shopName] = false
            }
            for product in viewModel.cart {
                selectedProducts[product.cart_item_id] = false
            }
        }
    }
}

struct CartProductView: View {
    let product: Cart
    @Binding var isSelected: Bool
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var quantity: Int
    
    init(product: Cart, isSelected: Binding<Bool>, viewModel: HomeViewModel) {
        self.product = product
        self._isSelected = isSelected
        self._quantity = State(initialValue: product.qty)
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button(action: {
                    isSelected.toggle()
                }) {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? Color("tertiary") : .gray)
                }
                
                WebImage(url: URL(string: product.productThumbnail))
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .allowsHitTesting(false)
                
//                Color.gray
//                    .frame(width: 80, height: 80)
//                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.storeName)
                        .font(AppFont.Nunito.footnoteSmall)
                        .foregroundColor(.gray)
                    
                    Text(product.productName)
                        .font(AppFont.Nunito.bodyMedium)
                        .bold()
                    
                    Text(product.storeLocation)
                        .font(AppFont.Nunito.footnoteSmall)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            HStack {
                Text("Rp\(product.productPrice, specifier: "%.2f")")
                    .font(AppFont.Crimson.titleMedium)
                    .bold()
                    .foregroundColor(Color("tertiary"))
                
                Spacer()
                
                Button(action: {
                    viewModel.deleteCartByIdItem(cartItemId: product.cart_item_id)
                }) {
                    Text("Hapus")
                        .font(AppFont.Nunito.footnoteSmall)
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Button(action: {
                    if quantity > 1 {
                        quantity -= 1
                        viewModel.decrementQuantity(cartItemId: product.cart_item_id)
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 12, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Text("\(quantity)")
                    .font(AppFont.Nunito.footnoteSmall)
                    .foregroundColor(.gray)
                    .frame(minWidth: 20, alignment: .center)
                
                Button(action: {
                    quantity += 1
                    viewModel.incrementQuantity(cartItemId: product.cart_item_id)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Rp\(product.productPrice * Double(quantity), specifier: "%.2f")")
                    .font(AppFont.Nunito.bodyMedium)
                    .bold()
            }
            .background(Color.clear)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}
