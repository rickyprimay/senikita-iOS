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
    let user: User?
    let data: User?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case status, message, code, data, user
        case expiresIn = "expires_in"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        status = try container.decode(String.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)
        code = try container.decode(Int.self, forKey: .code)

        let decodedData = try? container.decode(User.self, forKey: .data)
        let decodedUser = try? container.decode(User.self, forKey: .user)

        data = decodedData ?? decodedUser
        user = decodedUser ?? decodedData

        expiresIn = try? container.decode(Int.self, forKey: .expiresIn)

        if data == nil && user == nil {
            throw DecodingError.keyNotFound(
                CodingKeys.data,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Neither 'data' nor 'user' found in response"
                )
            )
        }
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        username = try? container.decode(String.self, forKey: .username)
        email = try? container.decode(String.self, forKey: .email)
        callNumber = try? container.decode(String.self, forKey: .callNumber)
        birthDate = try? container.decode(String.self, forKey: .birthDate)
        birthLocation = try? container.decode(String.self, forKey: .birthLocation)
        gender = try? container.decode(String.self, forKey: .gender)
        emailVerifiedAt = try? container.decode(String.self, forKey: .emailVerifiedAt)
        profilePicture = try? container.decode(String.self, forKey: .profilePicture)
        role = try? container.decode(Int.self, forKey: .role)
        token = try? container.decode(String.self, forKey: .token)

        if let intValue = try? container.decode(Int.self, forKey: .isHaveStore) {
            isHaveStore = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .isHaveStore),
                  let intFromString = Int(stringValue) {
            isHaveStore = intFromString
        } else {
            isHaveStore = nil
        }
    }
    
    init(
        id: Int,
        name: String? = nil,
        username: String? = nil,
        email: String? = nil,
        callNumber: String? = nil,
        birthDate: String? = nil,
        birthLocation: String? = nil,
        gender: String? = nil,
        emailVerifiedAt: String? = nil,
        profilePicture: String? = nil,
        isHaveStore: Int? = nil,
        role: Int? = nil,
        token: String? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.callNumber = callNumber
        self.birthDate = birthDate
        self.birthLocation = birthLocation
        self.gender = gender
        self.emailVerifiedAt = emailVerifiedAt
        self.profilePicture = profilePicture
        self.isHaveStore = isHaveStore
        self.role = role
        self.token = token
    }
}

struct PasswordUpdateResponse: Decodable {
    let code: Int
    let message: String
    let status: String
}
