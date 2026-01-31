//
//  Banner.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import SwiftUI

struct Banner: View {
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(24)
            
            // Hero image
            Image("hero")
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .offset(x: 20, y: -60)
            
            // Content overlay
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    // Welcome text
                    Text("Selamat datang")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("Jelajahi")
                        .font(AppFont.Nunito.headerMedium)
                        .foregroundColor(.white)
                    
                    // Highlighted tag
                    Text("Seni Kebudayaan Daerah")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color("brick"))
                        .cornerRadius(10)
                    
                    // Description
                    Text("Temukan karya seni dan layanan dari seniman lokal dengan Senikita. Marketplace pertama produk dan jasa kesenian di Indonesia")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.3)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .cornerRadius(20)
                )
                .padding(8)
            }
        }
        .frame(height: 300)
        .padding(.horizontal, 20)
        .shadow(color: Color("primary").opacity(0.3), radius: 12, y: 6)
    }
}
