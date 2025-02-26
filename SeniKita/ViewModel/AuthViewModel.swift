//
//  AuthViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 24/02/25.
//

import Foundation
import Alamofire
import SwiftUI

class AuthViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/auth"
    
    @Published var loginAlert = false
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        checkAuthentication()
    }
    
    func login(email: String, password: String) {
        isLoading = true
        let url = "\(baseUrl)/login"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                defer { DispatchQueue.main.async { self.isLoading = false } }
                
                switch response.result {
                case .success(let data):
                    do {
                        let authResponse = try JSONDecoder().decode(Auth.self, from: data)
                        
                        if authResponse.code == 200, let token = authResponse.user.token {
                            self.saveToken(token)
                            
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                                self.navigateAfterAuth(toRedirect: RootView())
                            }
                        } else {
                            print("Login Failed: \(authResponse.message)")
                        }
                    } catch {
                        print("JSON decode failed: \(error)")
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        let url = "\(baseUrl)/register"
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        print("📤 Sending request to: \(url)")
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: RegisterResponse.self) { response in
                DispatchQueue.main.async { self.isLoading = false }
                let statusCode = response.response?.statusCode ?? 0
                
                switch response.result {
                case .success(let result):
                    if (200..<300).contains(statusCode) {
                        print("✅ Registration successful: \(result.message)")
                        completion(true)
                    } else {
                        print("❌ Registration failed: \(result.message) | Status: \(statusCode)")
                        DispatchQueue.main.async {
                            self.errorMessage = result.message
                        }
                        completion(false)
                    }
                case .failure(let error):
                    print("🚨 Network error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.errorMessage = "An error occurred, please check your internet connection."
                    }
                    completion(false)
                }
            }
    }
    
    func resendOTP(email: String, completion: @escaping (String?) -> Void) {
        let url = "\(baseUrl)/resend-otp"
        let parameters: [String: String] = [
            "email": email
        ]
        
        print("📤 Sending OTP resend request to: \(url)")
        print("📦 Request parameters: \(parameters)")
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: RegisterResponse.self) { response in
                defer { DispatchQueue.main.async { self.isLoading = false } }
                
                let statusCode = response.response?.statusCode ?? 0
                print("📥 Received OTP resend response with status code: \(statusCode)")
                
                switch response.result {
                case .success(let result):
                    if (200..<300).contains(statusCode) {
                        print("✅ OTP resent successfully: \(result.message)")
                        completion(result.message)
                    } else {
                        print("❌ OTP resend failed: \(result.message) | Status: \(statusCode)")
                        completion("Failed to resend OTP, please try again later.")
                    }
                case .failure(let error):
                    print("🚨 OTP resend request failed: \(error.localizedDescription)")
                    completion("An error occurred, please check your internet connection.")
                }
            }
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    private func navigateAfterAuth(toRedirect: some View) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = scene.windows.first {
                    window.rootViewController = UIHostingController(rootView: toRedirect)
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    func checkAuthentication() {
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.navigateAfterAuth(toRedirect: Login())
        }
    }
}
