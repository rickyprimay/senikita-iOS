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
    
    func loginGoogle() {
        
    }
    
    func register() {
        
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.navigateAfterAuth(toRedirect: Login())
        }
    }
}
