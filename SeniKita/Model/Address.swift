//
//  Address.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//

struct SingleAddressResponse: Codable {
    let status: String
    let data: Address
}

struct AddressResponse: Codable {
    let status: String
    let data: [Address]
}

struct Address: Codable {
    let id: Int
    let user_id: Int
    let label_address: String
    let name: String
    let phone: String
    let address_detail: String
    let province_id: Int
    let city_id: Int
    let postal_code: String
    let note: String?
    let created_at: String
    let updated_at: String
    let city: City?
    let province: Province?
}

extension Address {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        
        // Handle user_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .user_id) {
            user_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .user_id) {
            user_id = intValue
        } else {
            user_id = 0
        }
        
        label_address = try container.decode(String.self, forKey: .label_address)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        address_detail = try container.decode(String.self, forKey: .address_detail)
        
        // Handle province_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .province_id) {
            province_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .province_id) {
            province_id = intValue
        } else {
            province_id = 0
        }
        
        // Handle city_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .city_id) {
            city_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .city_id) {
            city_id = intValue
        } else {
            city_id = 0
        }
        
        postal_code = try container.decode(String.self, forKey: .postal_code)
        note = try? container.decode(String.self, forKey: .note)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)
        city = try? container.decode(City.self, forKey: .city)
        province = try? container.decode(Province.self, forKey: .province)
    }
}
