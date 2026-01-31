//
//  SearchBar.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 01/02/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var isLoading: Bool
    
    var body: some View {
        if isLoading {
            searchBarSkeleton
        } else {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("primary").opacity(0.6))
                
                TextField("Cari produk atau jasa...", text: $text)
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(.primary)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(UIColor.systemGray3))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        }
    }
    
    private var searchBarSkeleton: some View {
        HStack(spacing: 12) {
            SkeletonLoading(width: 20, height: 20, isCircle: true)
            SkeletonLoading(width: .infinity, height: 16)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemBackground).opacity(0.5))
        .cornerRadius(14)
    }
}
