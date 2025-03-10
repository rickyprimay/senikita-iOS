//
//  Banner.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import SwiftUI

struct Banner: View {
    
    var body: some View {
        VStack {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color("primary"), Color("tertiary")]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: 340)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.top, 40)
                
                VStack {
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Selamat datang")
                            .font(AppFont.Nunito.footnoteLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Jelajahi")
                            .font(AppFont.Nunito.bodyMedium)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("Seni Kebudayaan Daerah")
                            .font(AppFont.Nunito.titleMedium)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color("brick"))
                            .cornerRadius(10)
                        
                        Text("Temukan karya seni dan layanan dari seniman lokal dengan Senikita. Marketplace pertama produk dan jasa kesenian di Indonesia")
                            .font(AppFont.Nunito.footnoteSmall)
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                
                VStack {
                    Image("hero")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .offset(x: -30, y: -100)
                }
            }
            .frame(height: 340)
            .padding(.vertical, 20)
        }
    }
}
