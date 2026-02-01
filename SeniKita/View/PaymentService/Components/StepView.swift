//
//  StepView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/05/25.
//

import SwiftUI

struct StepView: View {
    let stepNumber: String
    let title: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isActive ? Color("tertiary") : Color.white)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Circle()
                            .stroke(isActive ? Color.clear : Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: isActive ? Color("tertiary").opacity(0.3) : .clear, radius: 4, y: 2)
                
                Text(stepNumber)
                    .foregroundColor(isActive ? .white : .gray)
                    .font(AppFont.Nunito.footnoteLarge)
                    .bold()
            }

            Text(title)
                .font(AppFont.Raleway.footnoteSmall)
                .multilineTextAlignment(.center)
                .foregroundColor(isActive ? Color("tertiary") : .gray)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}
