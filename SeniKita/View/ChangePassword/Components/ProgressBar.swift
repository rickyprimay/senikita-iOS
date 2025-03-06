//
//  ProgressBar.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 04/03/25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * progress)
            }
            .animation(.linear(duration: 5), value: progress)
        }
    }
}
