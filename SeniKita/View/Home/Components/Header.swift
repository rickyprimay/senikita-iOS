//
//  Header.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI

struct Header: View {
    var body: some View {
        ZStack {
            Color("tertiary")
                .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                .edgesIgnoringSafeArea(.top)

            VStack(spacing: 10) {
                HStack {
                    Text("senikita")
                        .font(AppFont.Crimson.headerLarge)
                        .foregroundStyle(Color("primary"))
                        .tracking(2)
                        .padding(.horizontal)

                    Spacer()

                    ZStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        
                        badgeView(count: 3)
                    }
                    .padding(.horizontal, 2)

                    ZStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "cart")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        
                        badgeView(count: 5)
                    }
                    .padding(.trailing, 12)
                    .padding(.leading, 4)
                }
                .padding(.vertical, 10)

                HStack {
                    Text("Welcome Ricky")
                        .font(AppFont.Crimson.headerMedium)
                        .foregroundStyle(Color("secondary"))

                    Spacer()

                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 15)
        }
        .frame(height: 120)
    }
    
    @ViewBuilder
    private func badgeView(count: Int) -> some View {
        if count > 0 {
            Text("\(count)")
                .font(.caption2)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.red)
                .clipShape(Circle())
                .offset(x: 10, y: -10)
        }
    }
}
