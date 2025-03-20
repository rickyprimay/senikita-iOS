////
////  CartProductView.swift
////  SeniKita
////
////  Created by Ricky Primayuda Putra on 19/03/25.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct CartProductView: View {
//    let product: Cart
//    @Binding var isSelected: Bool
//    @ObservedObject var viewModel: HomeViewModel
//    
//    @State private var quantity: Int
//    
//    init(product: Cart, isSelected: Binding<Bool>, viewModel: HomeViewModel) {
//        self.product = product
//        self._isSelected = isSelected
//        self._quantity = State(initialValue: product.qty)
//        self.viewModel = viewModel
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                Button(action: {
//                    isSelected.toggle()
//                }) {
//                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
//                        .font(.system(size: 20))
//                        .foregroundColor(isSelected ? Color("tertiary") : .gray)
//                }
//                
//                WebImage(url: URL(string: product.productThumbnail))
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                    .cornerRadius(10)
//                
//                VStack(alignment: .leading, spacing: 5) {
//                    Text(product.storeName)
//                        .font(AppFont.Nunito.footnoteSmall)
//                        .foregroundColor(.gray)
//                    
//                    Text(product.productName)
//                        .font(AppFont.Nunito.bodyMedium)
//                        .bold()
//                    
//                    Text(product.storeLocation)
//                        .font(AppFont.Nunito.footnoteSmall)
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer()
//            }
//            
//            HStack {
//                Text("Rp\(product.productPrice, specifier: "%.2f")")
//                    .font(AppFont.Crimson.titleMedium)
//                    .bold()
//                    .foregroundColor(Color("tertiary"))
//                
//                Spacer()
//                
//                Button(action: {
//                    viewModel.deleteCartByIdItem(cartItemId: product.cart_item_id)
//                }) {
//                    Text("Hapus")
//                        .font(AppFont.Nunito.footnoteSmall)
//                        .foregroundColor(.red)
//                }
//            }
//            
//            HStack {
//                Button(action: {
//                    if quantity > 1 {
//                        quantity -= 1
//                        viewModel.decrementQuantity(cartItemId: product.cart_item_id)
//                    }
//                }) {
//                    Image(systemName: "minus")
//                        .font(.system(size: 12, weight: .bold))
//                        .frame(width: 20, height: 20)
//                        .background(Color.gray.opacity(0.2))
//                        .clipShape(Circle())
//                }
//                
//                Text("\(quantity)")
//                    .font(AppFont.Nunito.footnoteSmall)
//                    .foregroundColor(.gray)
//                    .frame(minWidth: 20, alignment: .center)
//                
//                Button(action: {
//                    quantity += 1
//                    viewModel.incrementQuantity(cartItemId: product.cart_item_id)
//                }) {
//                    Image(systemName: "plus")
//                        .font(.system(size: 12, weight: .bold))
//                        .frame(width: 20, height: 20)
//                        .background(Color.gray.opacity(0.2))
//                        .clipShape(Circle())
//                }
//                
//                Spacer()
//                
//                Text("Rp\(product.productPrice * Double(quantity), specifier: "%.2f")")
//                    .font(AppFont.Nunito.bodyMedium)
//                    .bold()
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 2)
//        .padding(.horizontal)
//    }
//}
