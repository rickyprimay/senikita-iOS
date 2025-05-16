//
//  CardProduct.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardProduct: View {
    
    let product: ProductData
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    @State private var isPopupVisible = false
    @State private var popupMessage = ""
    @State private var isSuccess = false
    
    var body: some View {
        VStack(spacing: 12) {
            productImage
            productDetails
        }
        .frame(width: 230)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 4)
        .padding(.horizontal, 8)
    }
    
    private var productImage: some View {
        ZStack(alignment: .topTrailing) {
            WebImage(url: URL(string: product.thumbnail ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 150)
                .clipped()
                .cornerRadius(15)
                .padding(.top, 10)
            
        }
    }
    
    private var productDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.category?.name ?? "")
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.orange)
            
            Text(product.name ?? "")
                .font(AppFont.Raleway.bodyMedium)
                .fontWeight(.regular)
                .lineLimit(1)
                .padding(.bottom, 2)
            
            Text("Rp\(product.price ?? 0)")
                .font(AppFont.Nunito.titleMedium)
                .fontWeight(.regular)
                .foregroundColor(.orange)
            
            Text(product.shop?.region ?? "")
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.gray)
            
            ratingAndCartButton
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }
    
    private var ratingAndCartButton: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 12))
            
            Text(String(format: "%.1f", product.average_rating ?? 0))
                .font(AppFont.Raleway.bodyMedium)
                .fontWeight(.regular)
                .foregroundColor(.gray)
            
            Text("| Terjual \(product.sold ?? 0)")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.gray)
            
            Spacer()
            
            cartButton
        }
    }
    
    private var cartButton: some View {
        Button(action: {
            homeViewModel.addProductToCart(productId: product.id, isLoad: true) { success, message in
                homeViewModel.showPopup(message: message, isSuccess: success)
            }
        }) {
            Image(systemName: "cart.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(LinearGradient(gradient: Gradient(colors: [Color("primary"), Color("tertiary")]), startPoint: .leading, endPoint: .trailing))
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }
}
