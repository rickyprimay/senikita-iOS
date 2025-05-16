//
//  CustomInputField.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 03/05/25.
//

import SwiftUI

struct CustomInputField: View {
    var title: String
    var tip: String?
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppFont.Crimson.bodyLarge)
                .bold()
            
            Text(tip ?? "")
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isFocused ? Color("brick") : Color.gray.opacity(0.5), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                )
                .focused($isFocused)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}
