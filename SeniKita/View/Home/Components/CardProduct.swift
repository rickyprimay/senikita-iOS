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
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                WebImage(url: URL(string: product.thumbnail ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 150)
                    .clipped()
                    .cornerRadius(15)
                    .padding(.top, 10)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.category?.name ?? "")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.orange)
                
                Text(product.name ?? "")
                    .font(AppFont.Raleway.bodyMedium)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.bottom, 2)
                
                Text("Rp\(product.price ?? 0)")
                    .font(AppFont.Nunito.titleMedium)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                Text(product.shop?.region ?? "")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(.gray)
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", product.average_rating ?? 0))
                        .font(AppFont.Raleway.bodyMedium)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Text("| Terjual \(product.sold ?? 0)")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        
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
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(width: 230)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.horizontal, 8)
    }
}
