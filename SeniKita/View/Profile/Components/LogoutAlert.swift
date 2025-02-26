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
                
                Text("Apakah Anda yakin ingin keluar?")
                    .font(AppFont.Crimson.bodyMedium)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        isShowing = false
                    }) {
                        Text("Batal")
                            .font(AppFont.Crimson.bodyMedium)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    
                    Button(action: {
                        onConfirm()
                        isShowing = false
                    }) {
                        Text("Keluar")
                            .font(AppFont.Crimson.bodyMedium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("customRed"))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                }
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
