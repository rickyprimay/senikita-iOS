//
//  LogoutAlert.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct LogoutAlert: View {
    @Binding var isShowing: Bool
    var onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isShowing = false
                    }
                }
            
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    
                    Text("Keluar dari Akun?")
                        .font(AppFont.Nunito.subtitle)
                        .foregroundColor(.primary)
                    
                    Text("Anda perlu masuk kembali untuk\nmengakses akun Anda")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                HStack(spacing: 12) {
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isShowing = false
                        }
                    } label: {
                        Text("Batal")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        onConfirm()
                        withAnimation(.easeOut(duration: 0.2)) {
                            isShowing = false
                        }
                    } label: {
                        Text("Keluar")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.15), radius: 20)
            .padding(.horizontal, 40)
            .transition(.scale.combined(with: .opacity))
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowing)
    }
}
