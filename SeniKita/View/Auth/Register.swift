//
//  Register.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

struct Register: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmationPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmationPasswordVisible: Bool = false
    
    var isFormValid: Bool {
        return !name.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmationPassword
    }
    
    var body: some View {
        VStack {
            TopAuth()
            Spacer()
            
            Text("Daftar di Senikita")
                .font(AppFont.Nunito.titleMedium)
                .bold()
            
            HStack {
                Text("Sudah punya akun?")
                    .font(AppFont.Nunito.footnoteLarge)
                
                NavigationLink(destination: Login()) {
                    Text("Masuk disini")
                        .foregroundColor(Color("brick"))
                        .font(AppFont.Nunito.footnoteLarge)
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Image("google-logo")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Masuk dengan Google")
                        .font(AppFont.Nunito.footnoteLarge)
                        .bold()
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, minHeight: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .padding(.vertical)
            }
            
            DividerLabel(label: "atau")
                .padding(.vertical, 4)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nama Lengkap")
                        .font(AppFont.Nunito.footnoteLarge)
                        .fontWeight(.semibold)
                    
                    TextField("Masukkan Nama Lengkap", text: $name)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(name.isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
                        )
                        .autocapitalization(.words)
                    
                    Text("Email")
                        .font(AppFont.Nunito.footnoteLarge)
                        .fontWeight(.semibold)
                    
                    TextField("Masukkan Email", text: $email)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(email.isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    Text("Password")
                        .font(AppFont.Nunito.footnoteLarge)
                        .fontWeight(.semibold)
                    
                    ZStack(alignment: .trailing) {
                        if isPasswordVisible {
                            TextField("Masukkan Password", text: $password)
                        } else {
                            SecureField("Masukkan Password", text: $password)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(password.isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
                    )
                    
                    Text("Konfirmasi Password")
                        .font(AppFont.Nunito.footnoteLarge)
                        .fontWeight(.semibold)
                    
                    ZStack(alignment: .trailing) {
                        if isConfirmationPasswordVisible {
                            TextField("Masukkan Ulang Password", text: $confirmationPassword)
                        } else {
                            SecureField("Masukkan Ulang Password", text: $confirmationPassword)
                        }
                        
                        Button(action: {
                            isConfirmationPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmationPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(confirmationPassword.isEmpty ? Color.gray.opacity(0.3) : (password == confirmationPassword ? Color("brick") : .red), lineWidth: 1)
                    )
                }
                .padding(.vertical)
            }
            .frame(height: 300)
            
            Button {
                
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
            .disabled(!isFormValid)
            
            Spacer()
        }
        .padding(30)
        .navigationBarHidden(true)
    }
}
