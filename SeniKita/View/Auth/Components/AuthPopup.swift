//
//  AuthPopup.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct AuthPopup: View {
    @Binding var isShowing: Bool
    var message: String
    var onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .onTapGesture {
                    isShowing = false
                }
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow)
                
                Text(message)
                    .font(AppFont.Crimson.bodyMedium)
                    .multilineTextAlignment(.center)
                
                Button(action: onConfirm) {
                    Text("OK")
                        .font(AppFont.Raleway.footnoteLarge)
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color("brick"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .frame(maxWidth: 300)
            .transition(.scale)
        }
    }
}
