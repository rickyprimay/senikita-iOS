//
//  ProfileEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//

import Foundation

enum ProfileEndpoint: Endpoint {
    case get
    case update(
        name: String,
        email: String,
        phone: String?,
        username: String?,
        birthDate: String?,
        birthLocation: String?,
        gender: String?
    )
    case changePassword(currentPassword: String, newPassword: String, confirmPassword: String)
    
    var path: String {
        switch self {
        case .get:
            return "auth/profile"
        case .update:
            return "user/edit-profile"
        case .changePassword:
            return "user/edit-profile/password"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .get:
            return .get
        case .update, .changePassword:
            return .put
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .update(let name, let email, let phone, let username, let birthDate, let birthLocation, let gender):
            var params: [String: Any] = ["name": name]
            if !email.isEmpty {
                params["email"] = email
            }
            if let phone = phone, !phone.isEmpty {
                params["call_number"] = phone
            }
            if let username = username, !username.isEmpty {
                params["username"] = username
            }
            if let birthDate = birthDate, !birthDate.isEmpty {
                params["birth_date"] = birthDate
            }
            if let birthLocation = birthLocation, !birthLocation.isEmpty {
                params["birth_location"] = birthLocation
            }
            if let gender = gender, !gender.isEmpty {
                let genderValue = (gender == "Laki-laki") ? "male" : "female"
                params["gender"] = genderValue
            }
            return params
        case .changePassword(let currentPassword, let newPassword, let confirmPassword):
            return [
                "old_password": currentPassword,
                "password": newPassword,
                "password_confirmation": confirmPassword
            ]
        default:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        return true
    }
}
