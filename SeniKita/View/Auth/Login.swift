//
//  Login.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isEmailValid: Bool = true
    @State private var showErrorPopup = false

    @FocusState private var emailFocus: Bool
    @FocusState private var passwordFocus: Bool

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
                        Text("Masuk ke Senikita")
                            .font(AppFont.Crimson.titleMedium)
                            .bold()
                        
                        HStack(spacing: 4) {
                            Text("Belum punya akun?")
                                .font(AppFont.Raleway.footnoteLarge)
                                .foregroundColor(.secondary)
                            
                            NavigationLink(destination: Register().environmentObject(authViewModel)) {
                                Text("Daftar disini")
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
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(AppFont.Nunito.bodyMedium)
                                .bold()
                            
                            HStack {
                                TextField("Masukkan Email", text: $email)
                                    .font(AppFont.Nunito.bodyMedium)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($emailFocus)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(emailFocus ? Color("tertiary") : Color.gray.opacity(0.3), lineWidth: 1.5)
                            )
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
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(AppFont.Nunito.bodyMedium)
                                .bold()
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("Masukkan Password", text: $password)
                                        .font(AppFont.Nunito.bodyMedium)
                                        .focused($passwordFocus)
                                } else {
                                    SecureField("Masukkan Password", text: $password)
                                        .font(AppFont.Nunito.bodyMedium)
                                        .focused($passwordFocus)
                                }
                                
                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(passwordFocus ? Color("tertiary") : Color.gray.opacity(0.3), lineWidth: 1.5)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Login Button
                    Button {
                        authViewModel.login(email: email, password: password) { success, message in
                            if !success {
                                showErrorPopup = true
                            }
                        }
                    } label: {
                        Text("Masuk")
                            .font(AppFont.Nunito.bodyLarge)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                Group {
                                    if email.isEmpty || password.isEmpty {
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
                            .shadow(color: (email.isEmpty || password.isEmpty) ? .clear : Color("tertiary").opacity(0.3), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            .onChange(of: authViewModel.errorMessage) { oldValue, newValue in
                if newValue != nil {
                    showErrorPopup = true
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
}
