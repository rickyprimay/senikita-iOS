//
//  RootView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI

struct RootView: View {
    
    @State private var selectedTab = 0
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                Home()
                    .tag(0)
                
                ArtMap()
                    .tag(1)
                
                Profile()
                    .tag(2)
            }
            .disabled(homeViewModel.isLoading)
            
            ZStack {
                HStack {
                    ForEach(TabbedItems.allCases, id: \.self) { item in
                        Button {
                            if !homeViewModel.isLoading {
                                selectedTab = item.rawValue
                            }
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                        .disabled(homeViewModel.isLoading)
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(Color("lightBrick").opacity(0.2))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case artMap
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Beranda"
        case .artMap:
            return "Peta"
        case .profile:
            return "Profil"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .artMap:
            return "map"
        case .profile:
            return "person"
        }
    }
}

extension RootView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .white : .gray)
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .white : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? 160 : 60, height: 60)
        .background(isActive ? Color("brick").opacity(0.4) : .clear)
        .cornerRadius(30)
    }
}
