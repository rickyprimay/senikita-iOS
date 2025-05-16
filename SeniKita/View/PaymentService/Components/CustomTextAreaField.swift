//
//  CustomTextAreaField.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 03/05/25.
//

import SwiftUI

struct CustomTextAreaField: View {
    var title: String
    var tip: String?
    var placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppFont.Crimson.bodyLarge)
                .bold()
            
            Text(tip ?? "")
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray.opacity(0.6))
                        .padding(12)
                        .font(AppFont.Raleway.bodyMedium)
                }
                
                TextEditor(text: $text)
                    .focused($isFocused)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .frame(minHeight: 120, maxHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color("brick") : Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
    }
}
