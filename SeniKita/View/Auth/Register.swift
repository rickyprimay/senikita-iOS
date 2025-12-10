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
        !name.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmationPassword
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    TopAuth()
                    Spacer()
                    
                    Text("Daftar di Senikita")
                        .font(AppFont.Crimson.titleMedium)
                        .bold()
                    
                    HStack {
                        Text("Sudah punya akun?")
                            .font(AppFont.Raleway.footnoteLarge)
                        
                        NavigationLink(destination: Login()) {
                            Text("Masuk disini")
                                .foregroundColor(Color("brick"))
                                .font(AppFont.Raleway.footnoteLarge)
                        }
                    }
                    
                    GoogleButton().environmentObject(authViewModel)
                    
                    DividerLabel(label: "atau").padding(.vertical, 4)
                    
                    RegisterForm(
                        name: $name,
                        email: $email,
                        password: $password,
                        confirmationPassword: $confirmationPassword,
                        isPasswordVisible: $isPasswordVisible,
                        isConfirmationPasswordVisible: $isConfirmationPasswordVisible,
                        nameFocus: $nameFocus,
                        emailFocus: $emailFocus,
                        passwordFocus: $passwordFocus,
                        confirmationPasswordFocus: $confirmationPasswordFocus
                    )
                    
                    Toggle(isOn: $isAgreed) {
                        Text("Saya menyetujui dengan mendaftarkan akun di Senikita")
                            .font(AppFont.Raleway.footnoteSmall)
                    }
                    .padding(.vertical)
                    
                    RegisterButton()
                    
                    Spacer()
                }
                .padding(30)
                
                NavigationLink("", destination: OTPInput(email: email).environmentObject(authViewModel), isActive: $isNavigatingToOTP)
                    .hidden()
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
    
    private func RegisterButton() -> some View {
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
                .font(AppFont.Nunito.footnoteLarge)
                .bold()
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(isFormValid ? Color("brick") : Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.top)
        .disabled(!isFormValid || !isAgreed)
    }
}
