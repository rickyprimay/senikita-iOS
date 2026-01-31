//
//  RootView.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @State private var isShowingTabBar = true
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var artMapViewModel = ArtMapViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    Home(profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                }
                .tag(0)
                .toolbar(.hidden, for: .tabBar)
                
                NavigationStack {
                    ArtMap(artMapViewModel: artMapViewModel)
                }
                .tag(1)
                .toolbar(.hidden, for: .tabBar)
                
                NavigationStack {
                    Profile(authViewModel: authViewModel, profileViewModel: profileViewModel)
                }
                .tag(2)
                .toolbar(.hidden, for: .tabBar)
            }
            .disabled(homeViewModel.isLoading)
            .environment(\.isShowingTabBar, $isShowingTabBar)

            if isShowingTabBar {
                customTabBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowingTabBar)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(TabbedItems.allCases, id: \.self) { item in
                TabBarButton(
                    item: item,
                    isSelected: selectedTab == item.rawValue,
                    action: {
                        if !homeViewModel.isLoading {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = item.rawValue
                            }
                        }
                    }
                )
                .disabled(homeViewModel.isLoading)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 12, y: 5)
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 40)
        .padding(.bottom, 4)
    }
}

struct TabBarButton: View {
    let item: TabbedItems
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color("primary"))
                            .frame(width: 36, height: 36)
                            .shadow(color: Color("primary").opacity(0.3), radius: 4, y: 2)
                    }
                    
                    Image(systemName: isSelected ? item.iconNameFilled : item.iconName)
                        .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? .white : .gray)
                }
                .frame(height: 36)
                
                Text(item.title)
                    .font(.system(size: 9, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color("primary") : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(TabBarButtonStyle())
    }
}

struct TabBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

private struct IsShowingTabBarKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(true)
}

extension EnvironmentValues {
    var isShowingTabBar: Binding<Bool> {
        get { self[IsShowingTabBarKey.self] }
        set { self[IsShowingTabBarKey.self] = newValue }
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
    
    var iconNameFilled: String {
        switch self {
        case .home:
            return "house.fill"
        case .artMap:
            return "map.fill"
        case .profile:
            return "person.fill"
        }
    }
}
