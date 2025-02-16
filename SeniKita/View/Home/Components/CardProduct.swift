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
        VStack(alignment: .leading, spacing: 8) {
            
            WebImage(url: URL(string: product.thumbnail ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 160)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(product.category?.name ?? "")
                    .font(AppFont.Raleway.footnoteSmall)
                    .fontWeight(.medium)
                    .foregroundStyle(.orange)
                
                Text(product.name ?? "")
                    .font(AppFont.Raleway.bodyMedium)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Rp\(product.price ?? 0)")
                    .font(AppFont.Nunito.titleMedium)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                    .padding(.vertical, 2)
                
                Text(product.shop?.region ?? "")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", product.average_rating ?? 0))
                        .font(AppFont.Raleway.bodyMedium)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Text("| Terjual \(product.sold ?? 0)")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.gray)
                }
            }
//                                        .padding(.horizontal, 10)
        }
        .frame(width: 220)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}
