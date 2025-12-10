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
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text("\(icon) \(text)")
                    .font(AppFont.Crimson.footnoteSmall)
                    .foregroundColor(Color("primary"))
                    .padding(.vertical, 12)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.1))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}
