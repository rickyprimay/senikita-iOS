//
//  ViewModifiers.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)
            
            if isLoading {
                LoadingOverlay(message: message)
            }
        }
    }
}

struct LoadingOverlay: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                if !message.isEmpty {
                    Text(message)
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .foregroundColor(.white)
                }
            }
            .padding(30)
            .background(Color("brick").opacity(0.9))
            .cornerRadius(16)
        }
    }
}

struct ErrorAlertModifier: ViewModifier {
    @Binding var error: String?
    let title: String
    
    var isPresented: Binding<Bool> {
        Binding(
            get: { error != nil },
            set: { if !$0 { error = nil } }
        )
    }
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: isPresented) {
                Button("OK", role: .cancel) {
                    error = nil
                }
            } message: {
                if let error = error {
                    Text(error)
                }
            }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var message: String?
    let duration: Double
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let message = message {
                VStack {
                    Spacer()
                    
                    Text(message)
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(25)
                        .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            self.message = nil
                        }
                    }
                }
            }
        }
        .animation(.spring(), value: message != nil)
    }
}

struct EmptyStateModifier: ViewModifier {
    let isEmpty: Bool
    let title: String
    let message: String
    let systemImage: String
    let action: (() -> Void)?
    let actionTitle: String?
    
    func body(content: Content) -> some View {
        if isEmpty {
            EmptyStateView(
                title: title,
                message: message,
                systemImage: systemImage,
                action: action,
                actionTitle: actionTitle
            )
        } else {
            content
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    let action: (() -> Void)?
    let actionTitle: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(Color("brick").opacity(0.6))
            
            Text(title)
                .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(.primary)
            
            Text(message)
                .font(.custom("Nunito-Regular", size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if let action = action, let actionTitle = actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.custom("Nunito-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color("brick"))
                        .cornerRadius(25)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.5),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + phase * geometry.size.width * 2)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func loading(isLoading: Bool, message: String = "Memuat...") -> some View {
        modifier(LoadingModifier(isLoading: isLoading, message: message))
    }
    
    func errorAlert(_ error: Binding<String?>, title: String = "Terjadi Kesalahan") -> some View {
        modifier(ErrorAlertModifier(error: error, title: title))
    }
    
    func toast(message: Binding<String?>, duration: Double = 2.0) -> some View {
        modifier(ToastModifier(message: message, duration: duration))
    }
    
    func emptyState(
        isEmpty: Bool,
        title: String,
        message: String,
        systemImage: String = "tray",
        action: (() -> Void)? = nil,
        actionTitle: String? = nil
    ) -> some View {
        modifier(EmptyStateModifier(
            isEmpty: isEmpty,
            title: title,
            message: message,
            systemImage: systemImage,
            action: action,
            actionTitle: actionTitle
        ))
    }
    
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
    
    func cardStyle(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 4) -> some View {
        self
            .background(Color.white)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, transform: (Self, T) -> Content) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}
