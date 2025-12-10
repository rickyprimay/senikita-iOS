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
    
    let baseUrl = "https://senikita.sirekampolkesyogya.my.id/api/auth"
    
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
            if error != nil {
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
            
            print("google token: \(idToken)")
            self.verifyGoogleToken(idToken)
        }
    }
    
    func verifyGoogleToken(_ idToken: String) {
        print("==========================================")
        print("🔵 STEP 1: verifyGoogleToken CALLED")
        print("🔵 Received idToken:", idToken)
        print("==========================================")

        DispatchQueue.main.async {
            print("🔵 STEP 2: Setting isLoading = true")
            self.isLoading = true
        }

        let url = "\(baseUrl)/verify-google"
        let parameters: [String: String] = ["id_token": idToken]

        print("🔵 STEP 3: Sending POST request to:", url)
        print("🔵 Parameters:", parameters)

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in

                print("==========================================")
                print("🟠 STEP 4: Response RECEIVED from server")
                print("🟠 Status Code:", response.response?.statusCode ?? 0)

                DispatchQueue.main.async {
                    print("🟠 Setting isLoading = false")
                    self.isLoading = false
                }

                switch response.result {

                case .success(let data):
                    print("🟢 STEP 5: SUCCESS - Raw Data received")

                    let jsonString = String(data: data, encoding: .utf8) ?? "no data"
                    print("🟢 STEP 6: RAW RESPONSE:", jsonString)

                    print("🟢 STEP 7: Trying to parse JSON")

                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        print("🟢 Parsed JSON:", json ?? [:])

                        let token =
                            json?["token"] as? String ??
                            (json?["data"] as? [String: Any])?["token"] as? String ??
                            (json?["user"] as? [String: Any])?["token"] as? String

                        print("🟢 STEP 8: Extracted token:", token ?? "nil")

                        if let token = token {
                            print("🟢 STEP 9: Saving token to UserDefaults")
                            self.saveToken(token)

                            print("🟢 STEP 10: Setting isAuthenticated = true")
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                                print("🔥 isAuthenticated changed to:", self.isAuthenticated)
                                
                                // Tunggu sebentar agar state ter-update
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    // Dismiss semua navigation stack untuk kembali ke root
                                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                                }
                            }

                            print("🟢 DONE: Google login success and state updated")

                        } else {
                            print("❌ ERROR: Token not found in response JSON")
                            self.errorMessage = "Token not found"
                        }

                    } catch {
                        print("❌ JSON PARSE ERROR:", error.localizedDescription)
                    }

                case .failure(let error):
                    print("❌ STEP 5: Request FAILED:", error.localizedDescription)
                }

                print("==========================================")
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
                    DispatchQueue.global(qos: .userInitiated).async {
                        do {
                            let authResponse = try JSONDecoder().decode(Auth.self, from: data)
                            DispatchQueue.main.async {
                                if authResponse.code == 200, let token = authResponse.data?.token {
                                    self.saveToken(token)
                                    self.isAuthenticated = true
                                    print("🔥 isAuthenticated changed to:", self.isAuthenticated)
                                    completion(true, "Login successful")
                                } else {
                                    let errorMessage = authResponse.message
                                    self.errorMessage = errorMessage
                                    completion(false, errorMessage)
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.errorMessage = "JSON decode failed: \(error.localizedDescription)"
                                completion(false, "JSON decode failed")
                            }
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
                case .failure(_):
                    DispatchQueue.main.async {
                        self.errorMessage = "An error occurred, please check your internet connection."
                    }
                    completion(false)
                }
            }
    }
    
    func verifyOTP(email: String, otp: String, completion: @escaping (Bool, String?) -> Void) {
        print("=======================================")
        print("🔵 VERIFY OTP CALLED")
        print("🔵 Email:", email)
        print("🔵 OTP:", otp)
        print("=======================================")

        DispatchQueue.main.async { self.isLoading = true }
        errorMessage = nil

        let url = "\(baseUrl)/verify-otp"
        let parameters: [String: String] = [
            "email": email,
            "otp": otp
        ]

        print("🔵 Sending request to:", url)
        print("🔵 Parameters:", parameters)

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                print("=======================================")
                print("🟠 RESPONSE RECEIVED")
                print("🟠 Status Code:", response.response?.statusCode ?? 0)

                DispatchQueue.main.async { self.isLoading = false }

                if let rawString = String(data: response.data ?? Data(), encoding: .utf8) {
                    print("🟠 RAW RESPONSE STRING:", rawString)
                }

                switch response.result {
                case .success(let data):
                    print("🟢 SUCCESS DATA RECEIVED")

                    do {
                        let decoded = try JSONDecoder().decode(Auth.self, from: data)
                        print("🟢 DECODE SUCCESS")
                        print("🟢 Message:", decoded.message)
                        print("🟢 Code:", decoded.code)
                        print("🟢 User Token:", decoded.data?.token ?? "nil")

                        if decoded.code != 200 {
                            print("❌ Server returned NON-200 code:", decoded.code)
                            completion(false, decoded.message)
                            return
                        }

                        let userData = decoded.data ?? decoded.user

                        guard let token = userData?.token else {
                            print("❌ Token missing in response")
                            completion(false, "Token not found")
                            return
                        }

                        print("🟢 SAVING TOKEN:", token)
                        self.saveToken(token)

                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                            print("🔥 isAuthenticated changed to:", self.isAuthenticated)
                        }

                        print("🟢 OTP VERIFIED SUCCESS")
                        completion(true, decoded.message)

                    } catch {
                        print("❌ DECODE ERROR:", error.localizedDescription)
                        completion(false, "JSON Decode Error")
                    }

                case .failure(let error):
                    print("❌ REQUEST FAILED:", error.localizedDescription)

                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("❌ ERROR JSON:", json)
                        completion(false, json["message"] as? String ?? "Unknown error")
                    } else {
                        completion(false, "Network error")
                    }
                }

                print("=======================================")
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
    
//    private func navigateAfterAuth(toRedirect: some View) {
//        DispatchQueue.main.async {
//            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                if let window = scene.windows.first {
//                    window.rootViewController = UIHostingController(rootView: toRedirect)
//                    window.makeKeyAndVisible()
//                }
//            }
//        }
//    }
    
    func checkAuthentication() {
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            DispatchQueue.main.async {
                self.isAuthenticated = true
                print("🔥 isAuthenticated changed to:", self.isAuthenticated)
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}
