//
//  RegisterForm.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct RegisterForm: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmationPassword: String
    @Binding var isPasswordVisible: Bool
    @Binding var isConfirmationPasswordVisible: Bool
    @State private var isEmailValid: Bool = true


    @FocusState.Binding var nameFocus: Bool
    @FocusState.Binding var emailFocus: Bool
    @FocusState.Binding var passwordFocus: Bool
    @FocusState.Binding var confirmationPasswordFocus: Bool

    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomTextField(
                label: "Nama Lengkap",
                text: $name,
                placeholder: "Masukkan Nama Lengkap",
                isSecure: false,
                nextFocus: $emailFocus,
                isLast: false
            )
            .focused($nameFocus)

            CustomTextField(
                label: "Email",
                text: $email,
                placeholder: "Masukkan Email",
                isSecure: false,
                keyboardType: .emailAddress,
                nextFocus: $passwordFocus,
                isLast: false
            )
            .focused($emailFocus)
            .onChange(of: email) { _ in
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
                nextFocus: $confirmationPasswordFocus,
                isLast: false
            )
            .focused($passwordFocus)
            
            PasswordField(
                label: "Konfirmasi Password",
                text: $confirmationPassword,
                isVisible: $isConfirmationPasswordVisible,
                nextFocus: nil,
                isLast: true
            )
            .focused($confirmationPasswordFocus)

            if !confirmationPassword.isEmpty && password != confirmationPassword {
                Text("Password tidak cocok")
                    .font(AppFont.Nunito.footnoteSmall)
                    .foregroundColor(Color("customRed"))
            }
        }
        .padding(.vertical)
    }
}
