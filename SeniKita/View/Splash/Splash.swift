//
//  Splash.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct Splash: View {
    
    @StateObject var authViewModel = AuthViewModel()
    @State private var isActive = false
    
    @State private var rotation: Double = 0
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        if isActive {
            NavigationStack {
                if authViewModel.isAuthenticated {
                    RootView()
                } else {
                    Login()
                }
            }
            .environmentObject(authViewModel)
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        Image("loading")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(rotation))
                            .onAppear {
                                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                                    rotation = 360
                                }
                            }
                            .overlay(
                                Rectangle()
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.5), Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .frame(width: 100, height: 100)
                                    .offset(x: shimmerOffset)
                                    .onAppear {
                                        withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                                            shimmerOffset = 200
                                        }
                                    }
                            )
                    }
                    
                    Text("senikita")
                        .font(AppFont.Crimson.headerLarge)
                        .foregroundStyle(Color("primary"))
                        .tracking(2)
                }
            }
            .onAppear {
                authViewModel.checkAuthentication()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isActive = true
                }
            }
        }
    }
}
