//
//  TopAuth.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 25/02/25.
//

import SwiftUI

struct TopAuth: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("brick").opacity(0.2))
                .frame(width: 250, height: 250)
                .offset(x: -100, y: -80)
                .blur(radius: 50)
            
            RoundedRectangle(cornerRadius: 40)
                .fill(Color("brick").opacity(0.3))
                .frame(width: 180, height: 120)
                .rotationEffect(.degrees(25))
                .offset(x: 100, y: -50)
                .blur(radius: 30)
            
            Image("hero")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
    }
}
