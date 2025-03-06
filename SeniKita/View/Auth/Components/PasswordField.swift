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
    @FocusState private var isFocused: Bool
    var nextFocus: FocusState<Bool>.Binding?
    var isLast: Bool
    var fontType: FontType
    
    enum FontType {
        case nunito
        case crimson
    }
    
    private var selectedFont: Font {
        switch fontType {
        case .nunito:
            return AppFont.Nunito.footnoteLarge
        case .crimson:
            return AppFont.Crimson.footnoteLarge
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(selectedFont)
                .fontWeight(.semibold)
            
            ZStack(alignment: .trailing) {
                if isVisible {
                    TextField("Masukkan \(label)", text: $text)
                        .focused($isFocused)
                        .submitLabel(isLast ? .done : .next)
                        .onSubmit {
                            nextFocus?.wrappedValue = true
                        }
                } else {
                    SecureField("Masukkan \(label)", text: $text)
                        .focused($isFocused)
                        .submitLabel(isLast ? .done : .next)
                        .onSubmit {
                            nextFocus?.wrappedValue = true
                        }
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
