//
//  CategoryButton.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 10/03/25.
//

import SwiftUI

struct CategoryButton: View {
    var icon: String
    var text: String

    var body: some View {
        HStack {
            Text("\(icon) \(text)")
                .font(AppFont.Crimson.subtitle)
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
        }
    }
}
