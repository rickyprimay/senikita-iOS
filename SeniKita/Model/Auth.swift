//
//  Auth.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 25/02/25.
//

struct Auth: Codable {
    let status: String
    let message: String
    let code: Int
    let user: User
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let callNumber: String?
    let birthDate: String?
    let birthLocation: String?
    let gender: String?
    let emailVerifiedAt: String?
    let profilePicture: String?
    let isHaveStore: Int?
    let role: Int?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case id, name, username, email, gender, role, token
        case callNumber = "call_number"
        case birthDate = "birth_date"
        case birthLocation = "birth_location"
        case emailVerifiedAt = "email_verified_at"
        case profilePicture = "profile_picture"
        case isHaveStore = "isHaveStore"
    }
}



