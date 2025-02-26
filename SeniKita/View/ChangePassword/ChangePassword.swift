//
//  ChangePassword.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//


import SwiftUI

struct ChangePassword: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isCurrentPasswordVisible: Bool = false
    @State private var isNewPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ubah Password")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Password Saat Ini")
                    .font(AppFont.Crimson.footnoteLarge)
                    .fontWeight(.semibold)
                
                ZStack(alignment: .trailing) {
                    if isCurrentPasswordVisible {
                        TextField("Masukkan Password Saat Ini", text: $currentPassword)
                    } else {
                        SecureField("Masukkan Password Saat Ini", text: $currentPassword)
                    }
                    
                    Button(action: {
                        isCurrentPasswordVisible.toggle()
                    }) {
                        Image(systemName: isCurrentPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentPassword.isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
                )
                
                Text("Password Baru")
                    .font(AppFont.Crimson.footnoteLarge)
                    .fontWeight(.semibold)
                
                ZStack(alignment: .trailing) {
                    if isNewPasswordVisible {
                        TextField("Masukkan Password Baru", text: $newPassword)
                    } else {
                        SecureField("Masukkan Password Baru", text: $newPassword)
                    }
                    
                    Button(action: {
                        isNewPasswordVisible.toggle()
                    }) {
                        Image(systemName: isNewPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(newPassword.isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
                )
                
                Text("Konfirmasi Password Baru")
                    .font(AppFont.Crimson.footnoteLarge)
                    .fontWeight(.semibold)
                
                ZStack(alignment: .trailing) {
                    if isConfirmPasswordVisible {
                        TextField("Masukkan Konfirmasi Password", text: $confirmPassword)
                    } else {
                        SecureField("Masukkan Konfirmasi Password", text: $confirmPassword)
                    }
                    
                    Button(action: {
                        isConfirmPasswordVisible.toggle()
                    }) {
                        Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(confirmPassword.isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
                )
            }
            .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: changePassword) {
                Text("Simpan")
                    .font(AppFont.Crimson.footnoteLarge)
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty ? Color.gray.opacity(0.5) : Color("brick"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty)
        }
        .padding()
    }
    
    private func changePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Semua kolom harus diisi."
            return
        }
        
        guard newPassword == confirmPassword else {
            errorMessage = "Password baru dan konfirmasi password tidak cocok."
            return
        }
        
        print("Password berhasil diubah")
    }
}
