//
//  OTPInput.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//


import SwiftUI

struct OTPInput: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?
    
    @State private var countdown: Int = 60
    @State private var isCountingDown = true
    private let maxCountdown = 60
    @State private var timer: Timer?
    @State private var showErrorPopup = false
    
    @StateObject var authViewModel = AuthViewModel()
    var email: String
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 16) {
                Text("Masukkan Kode OTP")
                    .font(AppFont.Crimson.titleMedium)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 60)
                
                Text("Silakan masukkan kode OTP yang telah dikirim ke nomor Anda.")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $otp[index])
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedIndex, equals: index)
                            .onChange(of: otp[index]) {
                                handleInputChange(otp[index], at: index)
                            }
                    }
                }
                .padding(.top, 10)
                
                HStack{
                    Text("Otp tidak terkirim? ")
                        .font(AppFont.Raleway.bodyMedium)
                    Button(action: resendOTP) {
                        Text(isCountingDown ? "Tunggu dalam \(formattedTime()) lagi" : "Kirim Ulang")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(Color("brick"))
                    }
                    .disabled(isCountingDown)
                }
                .padding(.top, 10)
                
                Button(action: {
                    verifyOTP()
                }) {
                    Text("Verifikasi")
                        .font(AppFont.Raleway.footnoteLarge)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("brick"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
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
                        .font(.system(size: 18, weight: .bold))
                }
                .tint(Color("brick"))
            }
        }
        .onAppear {
            startCountdown()
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
            DispatchQueue.main.async {
                if success {
                    print("✅ OTP berhasil diverifikasi!")
                } else {
                    showErrorPopup = true
                    print("❌ OTP gagal diverifikasi: \(message ?? "Unknown error")")
                }
            }
        }
    }
    
    
    private func formattedTime() -> String {
        let minutes = countdown / 60
        let seconds = countdown % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
}
