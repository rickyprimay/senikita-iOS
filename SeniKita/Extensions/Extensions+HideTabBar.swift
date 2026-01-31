//
//  Extensions+HideTabBar.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 01/02/25.
//

import SwiftUI

class TabBarVisibilityManager: ObservableObject {
    @Published var hideCount: Int = 0
    
    var isHidden: Bool {
        return hideCount > 0
    }
    
    func hide() {
        hideCount += 1
    }
    
    func show() {
        hideCount = max(0, hideCount - 1)
    }
}

private struct TabBarVisibilityManagerKey: EnvironmentKey {
    static let defaultValue: TabBarVisibilityManager = TabBarVisibilityManager()
}

extension EnvironmentValues {
    var tabBarManager: TabBarVisibilityManager {
        get { self[TabBarVisibilityManagerKey.self] }
        set { self[TabBarVisibilityManagerKey.self] = newValue }
    }
}

struct HideTabBarModifier: ViewModifier {
    @Environment(\.tabBarManager) var tabBarManager
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                tabBarManager.hide()
            }
            .onDisappear {
                tabBarManager.show()
            }
    }
}

extension View {
    func hideTabBar() -> some View {
        modifier(HideTabBarModifier())
    }
}
