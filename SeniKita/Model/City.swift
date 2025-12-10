//
//  City.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

struct CityResponse: Codable {
    let status: String
    let message: String
    let cities: [City]
}

struct City: Codable, Identifiable, Hashable {
    let id: Int
    let province_id: Int?
    let type: String?
    let name: String
    let postal_code: String?
    let province: Province?
    let created_at: String?
    let updated_at: String?
}

extension City {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        
        // Handle province_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .province_id) {
            province_id = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .province_id) {
            province_id = intValue
        } else {
            province_id = nil
        }
        
        type = try? container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        postal_code = try? container.decode(String.self, forKey: .postal_code)
        province = try? container.decode(Province.self, forKey: .province)
        created_at = try? container.decode(String.self, forKey: .created_at)
        updated_at = try? container.decode(String.self, forKey: .updated_at)
    }
}
