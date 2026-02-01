//
//  OTPInput.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct OTPInput: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?
    
    @State private var countdown: Int = 60
    @State private var isCountingDown = true
    private let maxCountdown = 60
    @State private var timer: Timer?
    @State private var showErrorPopup = false
    @State private var shouldDismissToRoot = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    var email: String
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    Text("Masukkan Kode OTP")
                        .font(AppFont.Crimson.titleMedium)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text("Silakan masukkan kode OTP yang telah dikirim ke nomor Anda.")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 16)
                    
                    // OTP Input Fields
                    HStack(spacing: 10) {
                        ForEach(0..<6, id: \.self) { index in
                            TextField("", text: $otp[index])
                                .frame(width: 48, height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            focusedIndex == index ? Color("tertiary") : Color.gray.opacity(0.3),
                                            lineWidth: focusedIndex == index ? 2 : 1
                                        )
                                )
                                .multilineTextAlignment(.center)
                                .font(AppFont.Nunito.titleMedium)
                                .keyboardType(.numberPad)
                                .focused($focusedIndex, equals: index)
                                .onChange(of: otp[index]) {
                                    handleInputChange(otp[index], at: index)
                                }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Resend OTP
                    HStack(spacing: 4) {
                        Text("Otp tidak terkirim?")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                        
                        Button(action: resendOTP) {
                            Text(isCountingDown ? "Tunggu dalam \(formattedTime()) lagi" : "Kirim Ulang")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(Color("tertiary"))
                                .bold()
                        }
                        .disabled(isCountingDown)
                    }
                    .padding(.top, 8)
                    
                    // Verify Button
                    Button(action: {
                        verifyOTP()
                    }) {
                        Text("Verifikasi")
                            .font(AppFont.Nunito.bodyLarge)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color("tertiary").opacity(0.3), radius: 8, y: 4)
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
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
        .navigationBarTitle("Verifikasi OTP", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("tertiary"))
                }
            }
        }
        .onAppear {
            startCountdown()
            focusedIndex = 0
        }
    }
    
    private func handleInputChange(_ newValue: String, at index: Int) {
        otp[index] = String(newValue.prefix(1))
        
        if !newValue.isEmpty {
            if index < 5 {
                focusedIndex = index + 1
            } else {
                focusedIndex = nil
            }
        } else {
            if index > 0 {
                focusedIndex = index - 1
            }
        }
    }
    
    private func resendOTP() {
        startCountdown()
        
        authViewModel.resendOTP(email: email) { message in
            DispatchQueue.main.async {
                if let message = message {
                    print("OTP Resent: \(message)")
                } else {
                    print("Failed to resend OTP")
                }
            }
        }
    }
    
    private func startCountdown() {
        timer?.invalidate()
        countdown = maxCountdown
        isCountingDown = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            DispatchQueue.main.async {
                if countdown > 0 {
                    countdown -= 1
                } else {
                    timer.invalidate()
                    isCountingDown = false
                }
            }
        }
    }
    
    private func verifyOTP() {
        let otpCode = otp.joined()
        guard otpCode.count == 6 else {
            print("OTP harus 6 digit")
            return
        }
        
        authViewModel.verifyOTP(email: email, otp: otpCode) { success, message in
            if success {
                print("✅ OTP berhasil diverifikasi!")
            } else {
                showErrorPopup = true
                print("❌ OTP gagal diverifikasi: \(message ?? "Unknown error")")
            }
        }
    }
    
    
    private func formattedTime() -> String {
        let minutes = countdown / 60
        let seconds = countdown % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
