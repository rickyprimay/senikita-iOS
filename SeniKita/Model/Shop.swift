//
//  Shop.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

struct Shop: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    let desc: String?
    let lat: String?
    let lng: String?
    let address: String?
    let profile_picture: String?
    let status: String?
    let balance: String?
    let city_id: String?
    let province_id: String?
    let user_id: String?
    let region: String?
    let city: City?
    let created_at: String?
    let updated_at: String?
}

extension Shop {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let strValue = try? container.decode(String.self, forKey: .id) {
            id = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .id) {
            id = intValue
        } else {
            id = nil
        }

        name = try? container.decode(String.self, forKey: .name)
        desc = try? container.decode(String.self, forKey: .desc)
        lat = try? container.decode(String.self, forKey: .lat)
        lng = try? container.decode(String.self, forKey: .lng)
        address = try? container.decode(String.self, forKey: .address)
        profile_picture = try? container.decode(String.self, forKey: .profile_picture)
        status = try? container.decode(String.self, forKey: .status)
        balance = try? container.decode(String.self, forKey: .balance)
        city_id = try? container.decode(String.self, forKey: .city_id)
        province_id = try? container.decode(String.self, forKey: .province_id)
        user_id = try? container.decode(String.self, forKey: .user_id)
        region = try? container.decode(String.self, forKey: .region)
        city = try? container.decode(City.self, forKey: .city)
        created_at = try? container.decode(String.self, forKey: .created_at)
        updated_at = try? container.decode(String.self, forKey: .updated_at)
    }
}
