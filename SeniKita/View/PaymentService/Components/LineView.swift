//
//  LineView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/05/25.
//

import SwiftUI


struct LineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 1)
            .frame(maxWidth: 20)
            .offset(y: -16)
    }
}
