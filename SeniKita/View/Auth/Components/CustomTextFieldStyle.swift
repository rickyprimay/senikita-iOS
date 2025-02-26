//
//  CustomTextFieldStyle.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    var isEmpty: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEmpty ? Color.gray.opacity(0.3) : Color("brick"), lineWidth: 1)
            )
    }
}
