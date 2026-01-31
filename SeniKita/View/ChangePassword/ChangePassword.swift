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
    @State private var showErrorPopup: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccessPopup: Bool = false
    
    @ObservedObject private var profileViewModel: ProfileViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }
    
    private var isFormValid: Bool {
        return !currentPassword.isEmpty &&
        newPassword.count >= 8 &&
        newPassword == confirmPassword
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        PasswordField(
                            label: "Password Saat Ini",
                            text: $currentPassword,
                            isVisible: $isCurrentPasswordVisible,
                            isLast: false,
                            fontType: .crimson
                        )
                        PasswordField(
                            label: "Password Baru",
                            text: $newPassword,
                            isVisible: $isNewPasswordVisible,
                            isLast: false,
                            fontType: .crimson
                        )
                        PasswordField(
                            label: "Konfirmasi Password Baru",
                            text: $confirmPassword,
                            isVisible: $isConfirmPasswordVisible,
                            isLast: true,
                            fontType: .crimson
                        )
                    }
                    .padding(.horizontal)
                    
                    Button(action: changePassword) {
                        Text(profileViewModel.isLoading ? "Loading..." : "Simpan")
                            .font(AppFont.Crimson.footnoteLarge)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(!isFormValid || profileViewModel.isLoading)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white.ignoresSafeArea())
                
                if showErrorPopup {
                    BasePopup(isShowing: $showErrorPopup, message: errorMessage, onConfirm: { showErrorPopup = false })
                        .transition(.opacity)
                        .zIndex(2)
                }
                
                if showSuccessPopup {
                    BasePopup(isShowing: $showSuccessPopup, message: "Password berhasil diperbarui!", onConfirm: {
                        showSuccessPopup = false
                        presentationMode.wrappedValue.dismiss()
                    }, isSuccess: true)
                    .transition(.opacity)
                    .zIndex(3)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .frame(width: 40, height: 40)
                        .background(Color.brown.opacity(0.3))
                        .clipShape(Circle())
                }
                .tint(Color("tertiary"))
            }
            ToolbarItem(placement: .principal) {
                Text("Ubah Password")
                    .font(AppFont.Crimson.bodyLarge)
                    .bold()
                    .foregroundColor(Color("tertiary"))
            }
        }
        .hideTabBar()
    }
    
    private func changePassword() {
        guard isFormValid else {
            showError("Password harus memiliki minimal 8 karakter dan kedua password baru harus sama.")
            return
        }
        
        profileViewModel.updatePassword(oldPassword: currentPassword, password: newPassword) { success, message in
            if success {
                errorMessage = message ?? "Password berhasil diperbarui."
                showSuccessPopup = true
            } else {
                showError(message ?? "Terjadi kesalahan, silakan coba lagi.")
            }
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showErrorPopup = true
    }
}
