//
//  CommonInputs.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI

struct SeniTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let errorMessage: String?
    
    @State private var isPasswordVisible: Bool = false
    
    init(
        title: String,
        placeholder: String = "",
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        errorMessage: String? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Nunito-SemiBold", size: 14))
                .foregroundColor(.primary)
            
            HStack {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(.custom("Nunito-Regular", size: 14))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.custom("Nunito-Regular", size: 14))
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .none : .sentences)
                }
                
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
            )
            
            if let error = errorMessage {
                Text(error)
                    .font(.custom("Nunito-Regular", size: 12))
                    .foregroundColor(.red)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    let onSearch: (() -> Void)?
    let onClear: (() -> Void)?
    
    init(
        text: Binding<String>,
        placeholder: String = "Cari...",
        onSearch: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSearch = onSearch
        self.onClear = onClear
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .font(.custom("Nunito-Regular", size: 14))
                .submitLabel(.search)
                .onSubmit {
                    onSearch?()
                }
            
            if !text.isEmpty {
                Button {
                    text = ""
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(25)
    }
}

struct TextArea: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat
    let maxLength: Int?
    
    init(
        title: String,
        placeholder: String = "",
        text: Binding<String>,
        minHeight: CGFloat = 100,
        maxLength: Int? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self.maxLength = maxLength
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.custom("Nunito-SemiBold", size: 14))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let maxLength = maxLength {
                    Text("\(text.count)/\(maxLength)")
                        .font(.custom("Nunito-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                
                TextEditor(text: $text)
                    .font(.custom("Nunito-Regular", size: 14))
                    .frame(minHeight: minHeight)
                    .scrollContentBackground(.hidden)
                    .onChange(of: text) { _, newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct DropdownPicker<T: Hashable>: View {
    let title: String
    let placeholder: String
    @Binding var selection: T?
    let options: [T]
    let displayText: (T) -> String
    
    @State private var isExpanded: Bool = false
    
    init(
        title: String,
        placeholder: String = "Pilih...",
        selection: Binding<T?>,
        options: [T],
        displayText: @escaping (T) -> String
    ) {
        self.title = title
        self.placeholder = placeholder
        self._selection = selection
        self.options = options
        self.displayText = displayText
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Nunito-SemiBold", size: 14))
                .foregroundColor(.primary)
            
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(selection.map(displayText) ?? placeholder)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(selection == nil ? .gray : .primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selection = option
                            withAnimation {
                                isExpanded = false
                            }
                        } label: {
                            HStack {
                                Text(displayText(option))
                                    .font(.custom("Nunito-Regular", size: 14))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selection == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color("brick"))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        
                        if option != options.last {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
            }
        }
    }
}

struct OTPTextField: View {
    @Binding var otp: String
    let length: Int
    
    init(otp: Binding<String>, length: Int = 6) {
        self._otp = otp
        self.length = length
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<length, id: \.self) { index in
                OTPDigitBox(
                    digit: getDigit(at: index),
                    isFocused: otp.count == index
                )
            }
        }
        .background(
            TextField("", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .opacity(0.001)
                .onChange(of: otp) { _, newValue in
                    if newValue.count > length {
                        otp = String(newValue.prefix(length))
                    }
                    otp = newValue.filter { $0.isNumber }
                }
        )
    }
    
    private func getDigit(at index: Int) -> String {
        guard index < otp.count else { return "" }
        return String(otp[otp.index(otp.startIndex, offsetBy: index)])
    }
}

struct OTPDigitBox: View {
    let digit: String
    let isFocused: Bool
    
    var body: some View {
        Text(digit)
            .font(.custom("Nunito-Bold", size: 24))
            .frame(width: 45, height: 55)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color("brick") : Color.clear, lineWidth: 2)
            )
    }
}
