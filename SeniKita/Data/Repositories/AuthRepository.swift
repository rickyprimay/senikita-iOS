//
//  AuthRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation


struct LoginResponse: Codable {
    let status: String
    let message: String
    let code: Int?
    let data: LoginData?
}

struct LoginData: Codable {
    let user: User
    let token: String
}

struct OTPResponse: Codable {
    let status: String
    let message: String
    let code: Int?
    let user: User?
}

struct BasicResponse: Codable {
    let status: String
    let message: String
    let code: Int?
}

final class AuthRepository: AuthRepositoryProtocol {
    private let sessionManager: SessionManagerProtocol
    private let client = HTTPClient.shared
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    func login(email: String, password: String) async throws -> User {
        let endpoint = AuthEndpoint.login(email: email, password: password)
        let response: LoginResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let data = response.data else {
            throw NetworkError.validationError(message: response.message)
        }
        
        sessionManager.saveToken(data.token)
        return data.user
    }
    
    func register(name: String, email: String, password: String) async throws -> String {
        let endpoint = AuthEndpoint.register(name: name, email: email, password: password)
        let response: BasicResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.validationError(message: response.message)
        }
        
        return response.message
    }
    
    func verifyOTP(email: String, otp: String) async throws -> User {
        let endpoint = AuthEndpoint.verifyOTP(email: email, otp: otp)
        let response: OTPResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let user = response.user, let token = user.token else {
            throw NetworkError.validationError(message: response.message)
        }
        
        sessionManager.saveToken(token)
        return user
    }
    
    func resendOTP(email: String) async throws -> String {
        let endpoint = AuthEndpoint.resendOTP(email: email)
        let response: BasicResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.validationError(message: response.message)
        }
        
        return response.message
    }
    
    func verifyGoogle(idToken: String) async throws -> User {
        let endpoint = AuthEndpoint.verifyGoogle(idToken: idToken)
        
        let rawData = try await client.requestRaw(endpoint: endpoint)
        
        guard let json = try? JSONSerialization.jsonObject(with: rawData) as? [String: Any] else {
            throw NetworkError.decodingFailed
        }
        
        let token = json["token"] as? String ??
                   (json["data"] as? [String: Any])?["token"] as? String ??
                   (json["user"] as? [String: Any])?["token"] as? String
        
        guard let extractedToken = token else {
            let message = json["message"] as? String ?? "Token tidak ditemukan"
            throw NetworkError.validationError(message: message)
        }
        
        sessionManager.saveToken(extractedToken)
        
        if let userData = json["user"] as? [String: Any] ?? 
           (json["data"] as? [String: Any])?["user"] as? [String: Any],
           let userJson = try? JSONSerialization.data(withJSONObject: userData),
           let user = try? JSONDecoder().decode(User.self, from: userJson) {
            return user
        }
        
        return User(id: 0, name: nil, username: nil, email: nil, callNumber: nil, birthDate: nil, birthLocation: nil, gender: nil, emailVerifiedAt: nil, profilePicture: nil, isHaveStore: nil, role: nil, token: extractedToken)
    }
    
    func getProfile() async throws -> User {
        let endpoint = AuthEndpoint.profile
        let response: Auth = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let user = response.user ?? response.data else {
            throw NetworkError.validationError(message: response.message)
        }
        
        return user
    }
    
    func logout() async throws {
        let endpoint = AuthEndpoint.logout
        let response: BasicResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.validationError(message: response.message)
        }
        
        sessionManager.clearSession()
    }
}
