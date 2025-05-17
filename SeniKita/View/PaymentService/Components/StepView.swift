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
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: isActive ? 0 : 1)
                    )
                Text(stepNumber)
                    .foregroundColor(isActive ? .white : .gray)
                    .font(.system(size: 14, weight: .semibold))
            }

            Text(title)
                .font(AppFont.Raleway.bodyMedium)
                .multilineTextAlignment(.center)
                .foregroundColor(isActive ? Color("tertiary") : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}
