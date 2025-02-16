//
//  ArtDetailView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI

struct ArtDetailView: View {
    var art: ArtMapResult
    var onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(art.name ?? "")
                    .font(AppFont.Crimson.headerMedium)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "x.circle")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.black)
                }
            }
            
            Text(art.subtitle ?? "")
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            
            Button(action: {}) {
                Text("Lihat lebih lanjut")
                    .font(AppFont.Crimson.footnoteSmall)
                    .foregroundStyle(Color("primary"))
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
