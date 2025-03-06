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
    let data: User

    enum CodingKeys: String, CodingKey {
        case status, message, code, data, user
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)
        code = try container.decode(Int.self, forKey: .code)

        if let userData = try? container.decode(User.self, forKey: .data) {
            data = userData
        } else if let userData = try? container.decode(User.self, forKey: .user) {
            data = userData
        } else {
            throw DecodingError.keyNotFound(
                CodingKeys.data,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Neither 'data' nor 'user' found in response")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(message, forKey: .message)
        try container.encode(code, forKey: .code)
        try container.encode(data, forKey: .data)
    }
}


struct User: Codable, Identifiable, Equatable {
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

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.username == rhs.username &&
               lhs.email == rhs.email &&
               lhs.callNumber == rhs.callNumber &&
               lhs.birthDate == rhs.birthDate &&
               lhs.birthLocation == rhs.birthLocation &&
               lhs.gender == rhs.gender &&
               lhs.emailVerifiedAt == rhs.emailVerifiedAt &&
               lhs.profilePicture == rhs.profilePicture &&
               lhs.isHaveStore == rhs.isHaveStore &&
               lhs.role == rhs.role &&
               lhs.token == rhs.token
    }
}


struct PasswordUpdateResponse: Decodable {
    let code: Int
    let message: String
    let status: String
}

