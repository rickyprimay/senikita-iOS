//
//  Extensions+HideTabBar.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI

struct HideTabBarModifier: ViewModifier {
    @Environment(\.isShowingTabBar) var isShowingTabBar
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                isShowingTabBar.wrappedValue = false
            }
            .onDisappear {
                isShowingTabBar.wrappedValue = true
            }
    }
}

extension View {
    func hideTabBar() -> some View {
        self.modifier(HideTabBarModifier())
    }
}
