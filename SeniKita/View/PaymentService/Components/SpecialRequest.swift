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
        VStack(spacing: 12) {
            CustomTextAreaField(
                title: "Catatan/Instruksi Tambahan",
                tip: "Jelaskan instruksi khusus yang Anda harapkan dari tim kami. Misalnya, preferensi pakaian, atau penyesuaian tema acara.",
                placeholder: "Masukkan perintah khusus atau intruksi tambahan",
                text: $additionalNote
            )
            
            HStack {
                Button{
                    withAnimation {
                        isStepTwo = false
                        if currentStep == 2 {
                            self.currentStep -= 1
                        }
                    }
                } label: {
                    Text("Kembali")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("secondary"))
                        .cornerRadius(10)
                }
                Button{
                    withAnimation {
                        isStepTwo = false
                        isStepThree = true
                        if currentStep < 3 {
                            self.currentStep += 1
                        }
                    }
                } label: {
                    Text("Selanjutnya")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .cornerRadius(10)
                }
            }
        }
    }
}
