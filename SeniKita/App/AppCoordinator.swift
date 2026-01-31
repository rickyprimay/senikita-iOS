//
//  AppCoordinator.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI


@MainActor
final class AppCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = true
    @Published var showSplash: Bool = true
    
    private let container: DIContainer
    private let sessionManager: SessionManagerProtocol
    
    init(container: DIContainer = .shared) {
        self.container = container
        self.sessionManager = container.sessionManager
        
        checkAuthenticationStatus()
    }
    
    private func checkAuthenticationStatus() {
        isAuthenticated = sessionManager.isLoggedIn
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSplash = false
            isLoading = false
        }
    }
    
    func login() {
        isAuthenticated = true
    }
    
    func logout() {
        sessionManager.clearSession()
        isAuthenticated = false
    }
    
    func refreshAuthState() {
        isAuthenticated = sessionManager.isLoggedIn
    }
}


@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var selectedTab: Int = 0
    @Published var cartItemCount: Int = 0
    @Published var showingCart: Bool = false
    @Published var showingNotification: Bool = false
    
    @Published var navigationPath = NavigationPath()
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private init() {}
    
    func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func resetNavigation() {
        navigationPath = NavigationPath()
        selectedTab = 0
    }
}
