//
//  CommonButtons.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(isLoading ? "Memuat..." : title)
                    .font(.custom("Nunito-Bold", size: 16))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isDisabled ? Color.gray : Color("brick"))
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .disabled(isLoading || isDisabled)
    }
}

struct SecondaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    init(
        title: String,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("brick")))
                        .scaleEffect(0.8)
                }
                
                Text(isLoading ? "Memuat..." : title)
                    .font(.custom("Nunito-SemiBold", size: 16))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.clear)
            .foregroundColor(Color("brick"))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color("brick"), lineWidth: 2)
            )
        }
        .disabled(isLoading)
    }
}

struct IconButton: View {
    let systemImage: String
    let size: CGFloat
    let color: Color
    let action: () -> Void
    
    init(
        systemImage: String,
        size: CGFloat = 24,
        color: Color = Color("brick"),
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.size = size
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: size))
                .foregroundColor(color)
        }
    }
}

struct CartButton: View {
    let itemCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .font(.system(size: 22))
                    .foregroundColor(Color("brick"))
                
                if itemCount > 0 {
                    Text("\(min(itemCount, 99))")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}

struct QuantityButton: View {
    @Binding var quantity: Int
    let minValue: Int
    let maxValue: Int
    let onIncrement: (() -> Void)?
    let onDecrement: (() -> Void)?
    
    init(
        quantity: Binding<Int>,
        minValue: Int = 1,
        maxValue: Int = 99,
        onIncrement: (() -> Void)? = nil,
        onDecrement: (() -> Void)? = nil
    ) {
        self._quantity = quantity
        self.minValue = minValue
        self.maxValue = maxValue
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                if quantity > minValue {
                    quantity -= 1
                    onDecrement?()
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(quantity > minValue ? Color("brick") : .gray)
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }
            .disabled(quantity <= minValue)
            
            Text("\(quantity)")
                .font(.custom("Nunito-Bold", size: 16))
                .frame(minWidth: 30)
            
            Button {
                if quantity < maxValue {
                    quantity += 1
                    onIncrement?()
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(quantity < maxValue ? Color("brick") : .gray)
                    .frame(width: 30, height: 30)
                    .background(Color("brick").opacity(0.1))
                    .clipShape(Circle())
            }
            .disabled(quantity >= maxValue)
        }
    }
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("brick"))
        }
    }
}

struct FloatingActionButton: View {
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color("brick"))
                .clipShape(Circle())
                .shadow(color: Color("brick").opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}
