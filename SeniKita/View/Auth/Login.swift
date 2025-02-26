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
    
    var body: some View {
        ZStack{
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
                    
                    VStack(alignment: .leading, spacing: 16) {
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
                        
                    }
                    .padding(.vertical)
                    
                    Button {
                        authViewModel.login(email: email, password: password)
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
        }
        .navigationBarHidden(true)
    }
}

