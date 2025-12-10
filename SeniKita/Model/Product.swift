//
//  Product.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation

struct Product: Codable {
    let status: String
    let code: Int
    let message: String
    let data: ProductResult
}

struct ProductResult: Codable {
    let current_page: Int
    let data: [ProductData]
}

struct ProductData: Codable, Identifiable {
    let id: Int
    let name: String?
    let price: Int?
    let desc: String?
    let stock: Int?
    let status: String?
    let thumbnail: String?
    let category_id: String?
    let shop_id: String?
    let sold: String?
    let average_rating: Double?
    let rating_count: Int?
    let category: Category?
    let shop: Shop?
    let created_at: String?
    let updated_at: String?
    let ratings: [Rating]?
}

extension ProductData {
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
        
        if let strValue = try? container.decode(String.self, forKey: .stock) {
            stock = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .stock) {
            stock = intValue
        } else {
            stock = nil
        }
        
        status = try? container.decode(String.self, forKey: .status)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
        category_id = try? container.decode(String.self, forKey: .category_id)
        shop_id = try? container.decode(String.self, forKey: .shop_id)
        sold = try? container.decode(String.self, forKey: .sold)
        average_rating = try? container.decode(Double.self, forKey: .average_rating)
        rating_count = try? container.decode(Int.self, forKey: .rating_count)
        category = try? container.decode(Category.self, forKey: .category)
        shop = try? container.decode(Shop.self, forKey: .shop)
        created_at = try? container.decode(String.self, forKey: .created_at)
        updated_at = try? container.decode(String.self, forKey: .updated_at)
        ratings = try? container.decode([Rating].self, forKey: .ratings)
    }
}
