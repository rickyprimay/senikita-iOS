//
//  TabButton.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//

import SwiftUI

struct TabButton: View {
    let title: String
    @Binding var selectedTab: String

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    selectedTab = title
                }
            }) {
                Text(title)
                    .font(AppFont.Crimson.bodyLarge)
                    .foregroundColor(selectedTab == title ? Color("primary") : .gray)
                    .padding(.bottom, 4)
            }

            Rectangle()
                .fill(selectedTab == title ? Color("primary") : Color.clear)
                .frame(height: 2)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
    }
}
