//
//  ProfileRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func getProfile() async throws -> User {
        let endpoint = ProfileEndpoint.get
        let response: Auth = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let user = response.user ?? response.data else {
            throw NetworkError.serverError(response.message)
        }
        
        return user
    }
    
    func updateProfile(name: String, email: String, phone: String?) async throws -> User {
        let endpoint = ProfileEndpoint.update(name: name, email: email, phone: phone)
        let response: Auth = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let user = response.user ?? response.data else {
            throw NetworkError.serverError(response.message)
        }
        
        return user
    }
    
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws -> String {
        let endpoint = ProfileEndpoint.changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        )
        let response: PasswordUpdateResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.message
    }
}
