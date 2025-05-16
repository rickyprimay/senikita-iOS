//  CustomTextField.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI

struct CustomTextField: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var keyboardType: UIKeyboardType = .default
    var fontType: FontType
    @FocusState private var isFocused: Bool
    var nextFocus: FocusState<Bool>.Binding?
    var isLast: Bool
    
    enum FontType {
        case nunito
        case crimson
    }
    
    private var selectedFont: Font {
        switch fontType {
        case .nunito:
            return AppFont.Raleway.footnoteLarge
        case .crimson:
            return AppFont.Crimson.footnoteLarge
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(selectedFont)
                .fontWeight(.semibold)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(CustomTextFieldStyle(isEmpty: text.isEmpty))
                    .focused($isFocused)
                    .submitLabel(isLast ? .done : .next)
                    .onSubmit {
                        nextFocus?.wrappedValue = true
                    }
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(CustomTextFieldStyle(isEmpty: text.isEmpty))
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .focused($isFocused)
                    .submitLabel(isLast ? .done : .next)
                    .onSubmit {
                        nextFocus?.wrappedValue = true
                    }
            }
        }
    }
}
