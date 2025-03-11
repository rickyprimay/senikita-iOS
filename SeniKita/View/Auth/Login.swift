//
//  Login.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

struct Login: View {
    @ObservedObject var authViewModel = AuthViewModel()
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
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TopAuth()
                        Spacer()
                        
                        Text("Masuk ke Senikita")
                            .font(AppFont.Nunito.titleMedium)
                            .bold()
                        
                        HStack {
                            Text("Belum punya akun?")
                                .font(AppFont.Nunito.footnoteLarge)
                            
                            NavigationLink(destination: Register()) {
                                Text("Daftar disini")
                                    .foregroundColor(Color("brick"))
                                    .font(AppFont.Nunito.footnoteLarge)
                            }
                        }
                        
                        GoogleButton()
                        
                        DividerLabel(label: "atau")

                        VStack(alignment: .leading, spacing: 16) {
                            CustomTextField(
                                label: "Email",
                                text: $email,
                                placeholder: "Masukkan Email",
                                isSecure: false,
                                keyboardType: .emailAddress,
                                fontType: .nunito,
                                nextFocus: $passwordFocus,
                                isLast: false
                            )
                            .focused($emailFocus)
                            .onChange(of: email) {
                                isEmailValid = isValidEmail
                            }
                            
                            if !isEmailValid {
                                Text("Format email tidak valid")
                                    .foregroundColor(.red)
                                    .font(AppFont.Nunito.footnoteSmall)
                            }
                            
                            PasswordField(
                                label: "Password",
                                text: $password,
                                isVisible: $isPasswordVisible,
                                nextFocus: nil,
                                isLast: true,
                                fontType: .nunito
                            )
                            .focused($passwordFocus)
                        }
                        .padding(.vertical)
                        
                        Button {
                            authViewModel.login(email: email, password: password) { success, message in
                                if success {
                                    showErrorPopup = false
                                } else {
                                    showErrorPopup = true
                                }
                            }
                        } label: {
                            Text("Masuk")
                                .font(AppFont.Nunito.footnoteLarge)
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(email.isEmpty || password.isEmpty ? Color.gray.opacity(0.5) : Color("brick"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                        .disabled(email.isEmpty || password.isEmpty)
                        
                        Spacer()
                    }
                    .padding(30)
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
}
