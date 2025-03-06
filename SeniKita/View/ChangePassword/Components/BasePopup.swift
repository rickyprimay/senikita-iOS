//
//  BasePopup.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 04/03/25.
//

import SwiftUI

struct BasePopup: View {
    @Binding var isShowing: Bool
    var message: String
    var onConfirm: () -> Void
    var isSuccess: Bool = false
    
    @State private var progress: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .onTapGesture {
                    isShowing = false
                }
            
            VStack(spacing: 20) {
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(isSuccess ? .green : .yellow)
                
                Text(message)
                    .font(AppFont.Crimson.bodyMedium)
                    .multilineTextAlignment(.center)
                
                Button(action: onConfirm) {
                    Text("OK")
                        .font(AppFont.Nunito.footnoteLarge)
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color("brick"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                ProgressBar(progress: progress, color: Color("brick"))
                    .frame(height: 5)
                    .cornerRadius(2.5)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .frame(maxWidth: 300)
            .transition(.scale)
            .onAppear {
                startAutoDismiss()
            }
        }
    }
    
    private func startAutoDismiss() {
        progress = 1.0
        withAnimation(.linear(duration: 5)) {
            progress = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if isShowing {
                isShowing = false
                onConfirm()
            }
        }
    }
}
