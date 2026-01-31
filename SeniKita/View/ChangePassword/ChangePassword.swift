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
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerCard
                        formCard
                        saveButton
                    }
                    .padding(20)
                }
            }
            
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .hideTabBar()
    }
    
    private var navigationHeader: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("primary"))
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            }
            
            Spacer()
            
            Text("Ubah Password")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var headerCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary").opacity(0.2), Color("tertiary").opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 4) {
                Text("Keamanan Akun")
                    .font(AppFont.Nunito.bodyLarge)
                    .foregroundColor(.primary)
                
                Text("Pastikan password baru minimal 8 karakter")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Informasi Password")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                PasswordField(
                    label: "Password Saat Ini",
                    text: $currentPassword,
                    isVisible: $isCurrentPasswordVisible,
                    isLast: false,
                    fontType: .nunito
                )
                
                Divider()
                
                PasswordField(
                    label: "Password Baru",
                    text: $newPassword,
                    isVisible: $isNewPasswordVisible,
                    isLast: false,
                    fontType: .nunito
                )
                
                if !newPassword.isEmpty && newPassword.count < 8 {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                        Text("Minimal 8 karakter")
                            .font(AppFont.Raleway.footnoteSmall)
                    }
                    .foregroundColor(.orange)
                    .padding(.leading, 4)
                }
                
                Divider()
                
                PasswordField(
                    label: "Konfirmasi Password Baru",
                    text: $confirmPassword,
                    isVisible: $isConfirmPasswordVisible,
                    isLast: true,
                    fontType: .nunito
                )
                
                if !confirmPassword.isEmpty && newPassword != confirmPassword {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                        Text("Password tidak cocok")
                            .font(AppFont.Raleway.footnoteSmall)
                    }
                    .foregroundColor(.red)
                    .padding(.leading, 4)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var saveButton: some View {
        Button(action: changePassword) {
            HStack(spacing: 8) {
                if profileViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 16))
                }
                
                Text(profileViewModel.isLoading ? "Menyimpan..." : "Simpan Password")
                    .font(AppFont.Nunito.bodyLarge)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isFormValid && !profileViewModel.isLoading {
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .cornerRadius(12)
            .shadow(color: isFormValid ? Color("primary").opacity(0.3) : Color.clear, radius: 8, y: 4)
        }
        .disabled(!isFormValid || profileViewModel.isLoading)
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
