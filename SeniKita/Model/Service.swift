//
//  Service.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation

struct ServiceResponse: Codable {
    let status: String
    let code: Int
    let message: String
    let data: ServiceResult
}

struct ServiceResult: Codable {
    let current_page: Int
    let data: [ServiceData]
}

struct ServiceData: Codable, Identifiable {
    let id: Int
    let name: String?
    let price: Int?
    let desc: String?
    let type: String?
    let status: String?
    let thumbnail: String?
    let sold: String?
    let person_amount: String?
    let category_id: String?
    let shop_id: String?
    let average_rating: Double?
    let rating_count: Int?
    let created_at: String?
    let updated_at: String?
    let category: Category?
    let shop: Shop?
}

extension ServiceData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        
        if let strValue = try? container.decode(String.self, forKey: .price) {
            price = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .price) {
            price = intValue
        } else {
            price = nil
        }
        
        desc = try? container.decode(String.self, forKey: .desc)
        type = try? container.decode(String.self, forKey: .type)
        status = try? container.decode(String.self, forKey: .status)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
        sold = try? container.decode(String.self, forKey: .sold)
        person_amount = try? container.decode(String.self, forKey: .person_amount)
        category_id = try? container.decode(String.self, forKey: .category_id)
        shop_id = try? container.decode(String.self, forKey: .shop_id)
        average_rating = try? container.decode(Double.self, forKey: .average_rating)
        rating_count = try? container.decode(Int.self, forKey: .rating_count)
        created_at = try? container.decode(String.self, forKey: .created_at)
        updated_at = try? container.decode(String.self, forKey: .updated_at)
        category = try? container.decode(Category.self, forKey: .category)
        shop = try? container.decode(Shop.self, forKey: .shop)
    }
}
