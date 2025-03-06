//
//  GoogleButton.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct GoogleButton: View {
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        Button {
            authViewModel.authenticateWithGoogle()
        } label: {
            HStack {
                Image("google-logo")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Masuk dengan Google")
                    .font(AppFont.Nunito.footnoteLarge)
                    .bold()
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, minHeight: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.8), lineWidth: 1)
            )
            .padding(.vertical)
        }
    }
}
