//
//  AppCoordinator.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import SwiftUI

// MARK: - App Coordinator
@MainActor
final class AppCoordinator: ObservableObject {
    // MARK: - Published Properties
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = true
    @Published var showSplash: Bool = true
    
    // MARK: - Dependencies
    private let container: DIContainer
    private let sessionManager: SessionManagerProtocol
    
    // MARK: - Initialization
    init(container: DIContainer = .shared) {
        self.container = container
        self.sessionManager = container.sessionManager
        
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Check
    private func checkAuthenticationStatus() {
        isAuthenticated = sessionManager.isLoggedIn
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSplash = false
            isLoading = false
        }
    }
    
    // MARK: - Authentication Actions
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

// MARK: - App State
@MainActor
final class AppState: ObservableObject {
    // MARK: - Singleton
    static let shared = AppState()
    
    // MARK: - Published Properties
    @Published var selectedTab: Int = 0
    @Published var cartItemCount: Int = 0
    @Published var showingCart: Bool = false
    @Published var showingNotification: Bool = false
    
    // MARK: - Navigation
    @Published var navigationPath = NavigationPath()
    
    // MARK: - Alert State
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private init() {}
    
    // MARK: - Methods
    func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func resetNavigation() {
        navigationPath = NavigationPath()
        selectedTab = 0
    }
}
