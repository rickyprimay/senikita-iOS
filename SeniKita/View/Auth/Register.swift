//
//  Register.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

struct Register: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmationPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmationPasswordVisible = false
    @State private var isAgreed = false
    @State private var isNavigatingToOTP = false
    @State private var showErrorPopup = false
    @State private var isEmailValid: Bool = true

    @FocusState private var nameFocus: Bool
    @FocusState private var emailFocus: Bool
    @FocusState private var passwordFocus: Bool
    @FocusState private var confirmationPasswordFocus: Bool

    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmationPassword && isAgreed
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    TopAuth()
                    
                    VStack(spacing: 8) {
                        Text("Daftar di Senikita")
                            .font(AppFont.Crimson.titleMedium)
                            .bold()
                        
                        HStack(spacing: 4) {
                            Text("Sudah punya akun?")
                                .font(AppFont.Raleway.footnoteLarge)
                                .foregroundColor(.secondary)
                            
                            NavigationLink(destination: Login()) {
                                Text("Masuk disini")
                                    .foregroundColor(Color("tertiary"))
                                    .font(AppFont.Raleway.footnoteLarge)
                                    .bold()
                            }
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Google Sign In Button
                    GoogleButton().environmentObject(authViewModel)
                        .padding(.horizontal, 24)
                    
                    DividerLabel(label: "atau")
                        .padding(.vertical, 16)
                    
                    // Form Fields
                    VStack(alignment: .leading, spacing: 20) {
                        // Name Field
                        formField(
                            title: "Nama Lengkap",
                            placeholder: "Masukkan Nama Lengkap",
                            text: $name,
                            isFocused: nameFocus
                        )
                        .focused($nameFocus)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            formField(
                                title: "Email",
                                placeholder: "Masukkan Email",
                                text: $email,
                                isFocused: emailFocus,
                                keyboardType: .emailAddress
                            )
                            .focused($emailFocus)
                            .onChange(of: email) {
                                isEmailValid = email.isEmpty || isValidEmail
                            }
                            
                            if !isEmailValid {
                                Text("Format email tidak valid")
                                    .foregroundColor(.red)
                                    .font(AppFont.Raleway.footnoteSmall)
                            }
                        }
                        
                        // Password Field
                        passwordField(
                            title: "Password",
                            placeholder: "Masukkan Password",
                            text: $password,
                            isVisible: $isPasswordVisible,
                            isFocused: passwordFocus
                        )
                        .focused($passwordFocus)
                        
                        // Confirmation Password Field
                        passwordField(
                            title: "Konfirmasi Password",
                            placeholder: "Masukkan Konfirmasi Password",
                            text: $confirmationPassword,
                            isVisible: $isConfirmationPasswordVisible,
                            isFocused: confirmationPasswordFocus
                        )
                        .focused($confirmationPasswordFocus)
                        
                        // Agreement Toggle
                        HStack(alignment: .top, spacing: 12) {
                            Text("Saya menyetujui dengan mendaftarkan akun di Senikita")
                                .font(AppFont.Raleway.footnoteSmall)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isAgreed)
                                .labelsHidden()
                                .tint(Color("tertiary"))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Register Button
                    Button {
                        authViewModel.register(name: name, email: email, password: password) { success in
                            if success {
                                isNavigatingToOTP = true
                            } else {
                                showErrorPopup = true
                            }
                        }
                    } label: {
                        Text("Daftar")
                            .font(AppFont.Nunito.bodyLarge)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                Group {
                                    if !isFormValid {
                                        Color.gray.opacity(0.5)
                                    } else {
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    }
                                }
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: !isFormValid ? .clear : Color("tertiary").opacity(0.3), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 30)
                    .disabled(!isFormValid)
                    
                    NavigationLink("", destination: OTPInput(email: email).environmentObject(authViewModel), isActive: $isNavigatingToOTP)
                        .hidden()
                }
            }
            
            if authViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            if showErrorPopup, let message = authViewModel.errorMessage {
                AuthPopup(isShowing: $showErrorPopup, message: message) {
                    showErrorPopup = false
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Helper Views
    
    private func formField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isFocused: Bool,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFont.Nunito.bodyMedium)
                .bold()
            
            TextField(placeholder, text: text)
                .font(AppFont.Nunito.bodyMedium)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color("tertiary") : Color.gray.opacity(0.3), lineWidth: 1.5)
                )
        }
    }
    
    private func passwordField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>,
        isFocused: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFont.Nunito.bodyMedium)
                .bold()
            
            HStack {
                if isVisible.wrappedValue {
                    TextField(placeholder, text: text)
                        .font(AppFont.Nunito.bodyMedium)
                } else {
                    SecureField(placeholder, text: text)
                        .font(AppFont.Nunito.bodyMedium)
                }
                
                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color("tertiary") : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
    }
}
