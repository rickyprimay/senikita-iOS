//
//  AuthEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum AuthEndpoint: Endpoint {
    case login(email: String, password: String)
    case register(name: String, email: String, password: String)
    case verifyGoogle(idToken: String)
    case verifyOTP(email: String, otp: String)
    case resendOTP(email: String)
    case profile
    case logout
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .register:
            return "auth/register"
        case .verifyGoogle:
            return "auth/verify-google"
        case .verifyOTP:
            return "auth/verify-otp"
        case .resendOTP:
            return "auth/resend-otp"
        case .profile:
            return "auth/profile"
        case .logout:
            return "auth/logout"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .profile:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .register(let name, let email, let password):
            return ["name": name, "email": email, "password": password]
        case .verifyGoogle(let idToken):
            return ["id_token": idToken]
        case .verifyOTP(let email, let otp):
            return ["email": email, "otp": otp]
        case .resendOTP(let email):
            return ["email": email]
        default:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .profile, .logout:
            return true
        default:
            return false
        }
    }
}
