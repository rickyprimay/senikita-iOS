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
                        .padding(.top)
                    
                    ForEach(groupedProducts.keys.sorted(), id: \.self) { shopName in
                        if let products = groupedProducts[shopName], let firstProduct = products.first {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Button(action: {
                                        selectedShops[shopName]?.toggle()
                                        let isSelected = selectedShops[shopName] ?? false
                                        for product in products {
                                            selectedProducts[product.cart_item_id] = isSelected
                                        }
                                    }) {
                                        Image(systemName: selectedShops[shopName] == true ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 22))
                                            .foregroundColor(selectedShops[shopName] == true ? Color("tertiary") : .gray)
                                            .padding(6)
                                            .background(Color.gray.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(shopName)
                                            .font(AppFont.Raleway.bodyMedium)
                                            .bold()
                                        
                                        Text(firstProduct.storeLocation)
                                            .font(AppFont.Raleway.footnoteLarge)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                ForEach(products, id: \.cart_item_id) { product in
                                    CartProductView(product: product, isSelected: Binding(
                                        get: { selectedProducts[product.cart_item_id] ?? false },
                                        set: { selectedProducts[product.cart_item_id] = $0 }
                                    ), viewModel: viewModel)
                                    .padding(.bottom, 8)
                                }
                            }
                            .padding(.vertical, 12)
                            .background(Color(.systemGroupedBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.bottom, 160)
            }
            .refreshable{
                viewModel.getCartProduct(isLoad: true)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .hideTabBar()
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
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Total Belanja")
                            .font(AppFont.Raleway.bodyMedium)
                            .bold()
                        
                        Spacer()
                        
                        Text("Rp\(totalHarga, specifier: "%.2f")")
                            .font(AppFont.Nunito.titleMedium)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    
                    Button(action: {
                       
                    }) {
                        Text("Beli (\(selectedProductCount))")
                            .font(AppFont.Nunito.bodyMedium)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color("tertiary").opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 12)
                .padding(.bottom, 25)
                .background(Color.white)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .ignoresSafeArea(edges: .bottom)
            .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 0)
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
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Button(action: {
                    isSelected.toggle()
                }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? Color("tertiary") : .gray)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.top, 4)
                
                HStack(alignment: .top, spacing: 12) {
                    WebImage(url: URL(string: product.productThumbnail))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.productName)
                            .font(AppFont.Raleway.bodyMedium)
                            .bold()
                            .lineLimit(2)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.storeName)
                                .font(AppFont.Raleway.footnoteSmall)
                                .foregroundColor(.secondary)
                            Text(product.storeLocation)
                                .font(AppFont.Raleway.footnoteSmall)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.deleteCartByIdItem(cartItemId: product.cart_item_id)
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .padding(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Divider()
            
            HStack(spacing: 20) {

                HStack(spacing: 12) {
                    Button(action: {
                        if product.qty > 1 {
                            viewModel.decrementQuantity(cartItemId: product.cart_item_id)
                        } else if product.qty == 1 {
                            viewModel.deleteCartByIdItem(cartItemId: product.cart_item_id)
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 36, height: 36)
                            .foregroundColor(product.qty > 1 ? .primary : .gray)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Text("\(product.qty)")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.gray)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        viewModel.incrementQuantity(cartItemId: product.cart_item_id)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 36, height: 36)
                            .foregroundColor(.primary)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                

                Text("Rp\(product.productPrice * Double(product.qty), specifier: "%.2f")")
                    .font(AppFont.Nunito.bodyMedium)
                    .bold()
                    .foregroundColor(Color("tertiary"))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }
}
