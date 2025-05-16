//
//  CardService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardService: View {
    let service: ServiceData
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                WebImage(url: URL(string: service.thumbnail ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 150)
                    .clipped()
                    .cornerRadius(15)
                    .padding(.top, 10)
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                categoryText
                nameText
                priceInfo
                regionText
                ratingAndCartButton
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(width: 230)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 4)
        .padding(.horizontal, 8)
    }
    
    private var categoryText: some View {
        Text(service.category?.name ?? "")
            .font(AppFont.Raleway.footnoteSmall)
            .foregroundColor(.orange)
    }
    
    private var nameText: some View {
        Text(service.name ?? "")
            .font(AppFont.Raleway.bodyMedium)
            .fontWeight(.regular)
            .lineLimit(1)
            .padding(.bottom, 2)
    }
    
    private var priceInfo: some View {
        HStack {
            Text("Rp\(service.price ?? 0)")
                .font(AppFont.Nunito.titleMedium)
                .fontWeight(.regular)
                .foregroundColor(.orange)
            
            Text("per \(service.type ?? "")")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.black)
        }
    }
    
    private var regionText: some View {
        Text(service.shop?.region ?? "")
            .font(AppFont.Raleway.footnoteSmall)
            .foregroundColor(.gray)
    }
    
    private var ratingAndCartButton: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 12))
            
            Text(String(format: "%.1f", service.average_rating ?? 0))
                .font(AppFont.Raleway.bodyMedium)
                .fontWeight(.regular)
                .foregroundColor(.gray)
            
            Text("| Terjual \(service.sold ?? 0)")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}
