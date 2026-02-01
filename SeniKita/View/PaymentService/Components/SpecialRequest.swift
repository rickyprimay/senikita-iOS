//
//  SpecialRequest.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/05/25.
//

import SwiftUI

struct SpecialRequest: View {
    @Binding var currentStep: Int
    @Binding var isStepTwo: Bool
    @State var additionalNote: String = ""
    @Binding var isStepThree: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Permintaan Khusus")
                    .font(AppFont.Nunito.titleMedium)
                    .bold()
                    .foregroundColor(.primary)
                
                Text("Tambahkan catatan atau instruksi khusus untuk pemesanan Anda")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)
            
            // Text Area
            CustomTextAreaField(
                title: "Catatan/Instruksi Tambahan",
                tip: "Jelaskan instruksi khusus yang Anda harapkan dari tim kami. Misalnya, preferensi pakaian, atau penyesuaian tema acara.",
                placeholder: "Masukkan perintah khusus atau instruksi tambahan",
                text: $additionalNote
            )
            
            // Buttons
            HStack(spacing: 12) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isStepTwo = false
                        if currentStep == 2 {
                            self.currentStep -= 1
                        }
                    }
                } label: {
                    Text("Kembali")
                        .font(AppFont.Nunito.bodyMedium)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("secondary"))
                        .cornerRadius(12)
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isStepTwo = false
                        isStepThree = true
                        if currentStep < 3 {
                            self.currentStep += 1
                        }
                    }
                } label: {
                    Text("Selanjutnya")
                        .font(AppFont.Nunito.bodyMedium)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color("primary").opacity(0.3), radius: 8, y: 4)
                }
            }
            .padding(.top, 8)
        }
    }
}
