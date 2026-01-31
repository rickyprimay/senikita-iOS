//
//  AuthViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthViewModel: ObservableObject {
    
    private let authRepository: AuthRepositoryProtocol
    private let sessionManager: SessionManagerProtocol
    
    @Published private(set) var user: User?
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var loginAlert: Bool = false
    
    init(
        authRepository: AuthRepositoryProtocol? = nil,
        sessionManager: SessionManagerProtocol? = nil
    ) {
        let container = DIContainer.shared
        self.authRepository = authRepository ?? container.authRepository
        self.sessionManager = sessionManager ?? container.sessionManager
        
        checkAuthentication()
    }
    
    func login(email: String, password: String) async -> (success: Bool, message: String?) {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let user = try await authRepository.login(email: email, password: password)
            self.user = user
            self.isAuthenticated = true
            return (true, "Login berhasil")
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            return (false, error.localizedDescription)
        } catch {
            errorMessage = error.localizedDescription
            return (false, error.localizedDescription)
        }
    }
    
    func register(name: String, email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            _ = try await authRepository.register(name: name, email: email, password: password)
            return true
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func verifyOTP(email: String, otp: String) async -> (success: Bool, message: String?) {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let user = try await authRepository.verifyOTP(email: email, otp: otp)
            self.user = user
            self.isAuthenticated = true
            return (true, "Verifikasi berhasil")
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            return (false, error.localizedDescription)
        } catch {
            errorMessage = error.localizedDescription
            return (false, error.localizedDescription)
        }
    }
    
    func resendOTP(email: String) async -> String? {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let message = try await authRepository.resendOTP(email: email)
            return message
        } catch let error as NetworkError {
            return error.localizedDescription
        } catch {
            return error.localizedDescription
        }
    }
    
    func authenticateWithGoogle() {
        isLoading = true
        
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
            isLoading = false
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if error != nil {
                Task { @MainActor in
                    self.isLoading = false
                }
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                Task { @MainActor in
                    self.isLoading = false
                }
                return
            }
            
            Task { @MainActor in
                await self.verifyGoogleToken(idToken)
            }
        }
    }
    
    func verifyGoogleToken(_ idToken: String) async {
        isLoading = true
        
        do {
            let user = try await authRepository.verifyGoogle(idToken: idToken)
            self.user = user
            self.isAuthenticated = true
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func fetchProfile() async {
        do {
            let user = try await authRepository.getProfile()
            self.user = user
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        sessionManager.clearSession()
        self.user = nil
        self.isAuthenticated = false
    }
    
    func checkAuthentication() {
        if sessionManager.isLoggedIn {
            isAuthenticated = true
            Task {
                await fetchProfile()
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Task {
            let result = await login(email: email, password: password)
            completion(result.success, result.message)
        }
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Task {
            let success = await register(name: name, email: email, password: password)
            completion(success)
        }
    }
    
    func verifyOTP(email: String, otp: String, completion: @escaping (Bool, String?) -> Void) {
        Task {
            let result = await verifyOTP(email: email, otp: otp)
            completion(result.success, result.message)
        }
    }
    
    func resendOTP(email: String, completion: @escaping (String?) -> Void) {
        Task {
            let message = await resendOTP(email: email)
            completion(message)
        }
    }
}
