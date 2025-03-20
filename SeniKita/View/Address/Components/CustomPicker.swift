//
//  CustomPicker.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 18/03/25.
//

import SwiftUI

struct CustomPicker<T: Identifiable & Hashable>: View {
    var label: String
    @Binding var selection: T?
    var options: [T]
    var displayProperty: KeyPath<T, String>
    
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFont.Crimson.footnoteLarge)
                .bold()
            
            Button(action: {
                isPickerPresented = true
            }) {
                HStack {
                    Text(selection?[keyPath: displayProperty] ?? "Pilih \(label)")
                        .foregroundColor(selection == nil ? .gray : .black)
                        .font(AppFont.Crimson.footnoteLarge)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .sheet(isPresented: $isPickerPresented) {
                NavigationView {
                    PickerListView(title: label, options: options, displayProperty: displayProperty, selection: $selection)
                }
            }
        }
    }
}
