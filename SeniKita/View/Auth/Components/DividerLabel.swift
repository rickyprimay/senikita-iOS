//
//  DividerLabel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 25/02/25.
//

import SwiftUI

struct DividerLabel: View {
    var label: String
    var color: Color = .gray
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(color)
            Text(label)
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(color)
        }
    }
}
