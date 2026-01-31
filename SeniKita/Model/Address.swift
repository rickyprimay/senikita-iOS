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

    init(
        id: Int,
        user_id: Int,
        label_address: String,
        name: String,
        phone: String,
        address_detail: String,
        province_id: Int,
        city_id: Int,
        postal_code: String,
        note: String?,
        created_at: String,
        updated_at: String,
        city: City?,
        province: Province?
    ) {
        self.id = id
        self.user_id = user_id
        self.label_address = label_address
        self.name = name
        self.phone = phone
        self.address_detail = address_detail
        self.province_id = province_id
        self.city_id = city_id
        self.postal_code = postal_code
        self.note = note
        self.created_at = created_at
        self.updated_at = updated_at
        self.city = city
        self.province = province
    }
}

extension Address {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        
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
        
        if let strValue = try? container.decode(String.self, forKey: .province_id) {
            province_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .province_id) {
            province_id = intValue
        } else {
            province_id = 0
        }
        
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
