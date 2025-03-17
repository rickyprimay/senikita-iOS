//
//  PickerListView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 18/03/25.
//

import SwiftUI


struct PickerListView<T: Identifiable & Hashable>: View {
    var title: String
    var options: [T]
    var displayProperty: KeyPath<T, String>
    @Binding var selection: T?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(options, id: \.id) { option in
                Button(action: {
                    selection = option
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(option[keyPath: displayProperty])
                            .foregroundColor(.black)
                        Spacer()
                        if selection?.id == option.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .font(AppFont.Crimson.footnoteLarge)
                }
            }
        }
        .navigationTitle(title)
    }
}
