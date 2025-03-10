//
//  AuthViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 24/02/25.
//

import Foundation
import Alamofire
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

class AuthViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/auth"
    
    @Published var loginAlert = false
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        checkAuthentication()
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
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            self.verifyGoogleToken(idToken)
        }
    }
    
    func verifyGoogleToken(_ idToken: String) {
        DispatchQueue.main.async { self.isLoading = true }
        let url = "\(baseUrl)/verify-google"
        let parameters: [String: String] = ["id_token": idToken]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                defer { DispatchQueue.main.async { self.isLoading = false } }
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(Auth.self, from: data)
                        
                        if let token = decodedResponse.data.token {
                            self.saveToken(token)
                            
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                                self.navigateAfterAuth(toRedirect: RootView())
                            }
                        }
                    } catch {
                        print("❌ JSON Decoding Error: \(error.localizedDescription)")
                    }

                case .failure(let error):
                    print("❌ Request failed: \(error.localizedDescription)")
                }
            }
    }
    
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        isLoading = true
        errorMessage = nil
        
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
                        
                        if authResponse.code == 200, let token = authResponse.data.token {
                            self.saveToken(token)
                            
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                                self.navigateAfterAuth(toRedirect: RootView())
                            }
                            completion(true, "Login successful")
                        } else {
                            let errorMessage = authResponse.message
                            print("Login Failed: \(errorMessage)")
                            DispatchQueue.main.async {
                                self.errorMessage = errorMessage
                            }
                            completion(false, errorMessage)
                        }
                    } catch {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            print("Server Error: \(errorResponse.message) (Code: \(errorResponse.code))")
                            DispatchQueue.main.async {
                                self.errorMessage = errorResponse.message
                            }
                            completion(false, errorResponse.message)
                        } catch {
                            let decodingErrorMessage = "JSON decode failed: \(error.localizedDescription)"
                            print(decodingErrorMessage)
                            DispatchQueue.main.async {
                                self.errorMessage = decodingErrorMessage
                            }
                            completion(false, decodingErrorMessage)
                        }
                    }
                    
                case .failure(let error):
                    let requestErrorMessage = "Request failed: \(error.localizedDescription)"
                    print(requestErrorMessage)
                    DispatchQueue.main.async {
                        self.errorMessage = requestErrorMessage
                    }
                    completion(false, requestErrorMessage)
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
                        completion(true)
                    } else {
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
    
    func verifyOTP(email: String, otp: String, completion: @escaping (Bool, String?) -> Void) {
        DispatchQueue.main.async { self.isLoading = true }
        errorMessage = nil
        
        let url = "\(baseUrl)/verify-otp"
        let parameters: [String: String] = [
            "email": email,
            "otp": otp
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: Auth.self) { response in
                defer { DispatchQueue.main.async { self.isLoading = false } }
                let statusCode = response.response?.statusCode ?? 0
                
                switch response.result {
                case .success(let result):
                    if (200..<300).contains(statusCode) {
                        
                        if let token = result.data.token {
                            self.saveToken(token)
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                                self.navigateAfterAuth(toRedirect: RootView())
                            }
                            completion(true, "Verification successful")
                        } else {
                            completion(false, "No token received")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = result.message
                        }
                        completion(false, result.message)
                    }
                case .failure(let error):
                    if let data = response.data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       var message = jsonObject["message"] as? String {
                        
                        if message == "Invalid OTP" {
                            message = "OTP salah, silahkan cek kembali"
                        }
                        
                        DispatchQueue.main.async {
                            self.errorMessage = message
                        }
                        completion(false, message)
                    } else {
                        
                        DispatchQueue.main.async {
                            self.errorMessage = "An error occurred, please check your internet connection."
                        }
                        completion(false, "An error occurred, please try again.")
                    }
                    
                }
            }
    }
    
    func resendOTP(email: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.main.async { self.isLoading = true }
        
        let url = "\(baseUrl)/resend-otp"
        let parameters: [String: String] = [
            "email": email
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: RegisterResponse.self) { response in
                defer { DispatchQueue.main.async { self.isLoading = false } }
                
                let statusCode = response.response?.statusCode ?? 0
                
                switch response.result {
                case .success(let result):
                    if (200..<300).contains(statusCode) {
                        completion(result.message)
                    } else {
                        completion("Failed to resend OTP, please try again later.")
                    }
                case .failure(let error):
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
