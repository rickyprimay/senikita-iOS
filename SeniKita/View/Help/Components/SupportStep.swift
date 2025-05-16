//
//  SupportStep.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

import SwiftUI

struct SupportStep: View {
    
    let step: (icon: String, title: String, description: String)
    let isLastItem: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                
                Image(systemName: step.icon)
                    .foregroundStyle(Color("primary"))
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(Color("tertiary").opacity(0.5))
                    .clipShape(Circle())
                
                if !isLastItem {
                    Rectangle()
                        .fill(Color("primary").opacity(0.5))
                        .frame(width: 2, height: 120)
                }
                
            }
            
            VStack(alignment: .leading) {
                Text(step.title)
                    .font(AppFont.Crimson.subtitle)
                    .foregroundColor(Color("primary"))

                Text(step.description)
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(Color("secondary"))
            }
        }
        .padding(.horizontal, 24)
    }
    
}
