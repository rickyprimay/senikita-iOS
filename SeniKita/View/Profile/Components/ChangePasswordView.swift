//
//  ChangePasswordView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//


import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ubah Password")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            SecureField("Password Saat Ini", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password Baru", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Konfirmasi Password Baru", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: changePassword) {
                Text("Simpan")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("brick"))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
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
        
        // Tambahkan logika untuk mengubah password di sini
        print("Password berhasil diubah")
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
