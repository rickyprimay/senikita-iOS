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
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomTextField(label: "Nama Lengkap", text: $name, placeholder: "Masukkan Nama Lengkap", isSecure: false)
            CustomTextField(label: "Email", text: $email, placeholder: "Masukkan Email", isSecure: false, keyboardType: .emailAddress)
                .onChange(of: email) { newValue in
                    isEmailValid = isValidEmail
                }
            
            if !isEmailValid {
                Text("Format email tidak valid")
                    .foregroundColor(.red)
                    .font(AppFont.Nunito.footnoteSmall)
            }
            
            PasswordField(label: "Password", text: $password, isVisible: $isPasswordVisible)
            PasswordField(label: "Konfirmasi Password", text: $confirmationPassword, isVisible: $isConfirmationPasswordVisible)
            
            if !confirmationPassword.isEmpty && password != confirmationPassword {
                Text("Password tidak cocok")
                    .font(AppFont.Nunito.footnoteSmall)
                    .foregroundColor(Color("customRed"))
            }
        }
        .padding(.vertical)
    }
}
