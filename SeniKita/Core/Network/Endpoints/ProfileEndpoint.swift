//
//  ProfileEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum ProfileEndpoint: Endpoint {
    case get
    case updateProfile(name: String, email: String, phone: String?)
    case update(name: String, email: String, phone: String?)
    case changePassword(currentPassword: String, newPassword: String, confirmPassword: String)
    
    var path: String {
        switch self {
        case .get:
            return "auth/profile"
        case .updateProfile, .update:
            return "user/edit-profile"
        case .changePassword:
            return "user/edit-profile/password"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .get:
            return .get
        case .updateProfile, .update, .changePassword:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .updateProfile(let name, let email, let phone), .update(let name, let email, let phone):
            var params: [String: Any] = ["name": name, "email": email]
            if let phone = phone {
                params["phone"] = phone
            }
            return params
        case .changePassword(let currentPassword, let newPassword, let confirmPassword):
            return [
                "current_password": currentPassword,
                "new_password": newPassword,
                "new_password_confirmation": confirmPassword
            ]
        default:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        return true
    }
}
