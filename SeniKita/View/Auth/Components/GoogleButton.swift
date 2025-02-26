//
//  GoogleButton.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct GoogleButton: View {
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Image("google-logo")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Masuk dengan Google")
                    .font(AppFont.Nunito.footnoteLarge)
                    .bold()
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, minHeight: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.8), lineWidth: 1)
            )
            .padding(.vertical)
        }
    }
}
