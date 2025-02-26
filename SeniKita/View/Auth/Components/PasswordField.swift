//
//  PasswordField.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct PasswordField: View {
    var label: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(AppFont.Nunito.footnoteLarge)
                .fontWeight(.semibold)
            
            ZStack(alignment: .trailing) {
                if isVisible {
                    TextField("Masukkan \(label)", text: $text)
                } else {
                    SecureField("Masukkan \(label)", text: $text)
                }
                
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 12)
            }
            .textFieldStyle(CustomTextFieldStyle(isEmpty: text.isEmpty))
        }
    }
}
