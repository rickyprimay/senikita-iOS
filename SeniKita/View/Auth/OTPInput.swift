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
    
    @State private var countdown: Int = 0
    @State private var isCountingDown = false
    private let maxCountdown = 60
    
    @StateObject var authViewModel = AuthViewModel()
    var email: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Masukkan Kode OTP")
                .font(AppFont.Nunito.titleMedium)
                .bold()
                .foregroundColor(.black)
                .padding(.top, 60)
            
            Text("Silakan masukkan kode OTP yang telah dikirim ke nomor Anda.")
                .font(AppFont.Nunito.bodyMedium)
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
                }
            }
            .padding(.top, 10)
            
            Button(action: resendOTP) {
                Text(isCountingDown ? "Tunggu dalam \(formattedTime()) lagi" : "Kirim Ulang")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(Color("brick"))
                    .padding(.top, 10)
            }
            .disabled(isCountingDown)
            
            Button(action: {
                print("OTP: \(otp.joined())")
            }) {
                Text("Verifikasi")
                    .font(AppFont.Nunito.footnoteLarge)
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
        countdown = maxCountdown
        isCountingDown = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                isCountingDown = false
            }
        }
        authViewModel.resendOTP(email: email){ _ in
            print("success")
        }
    }
    
    private func formattedTime() -> String {
        let minutes = countdown / 60
        let seconds = countdown % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
}
