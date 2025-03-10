//
//  Product.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation

struct Product: Codable {
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
    let status: Int?
    let thumbnail: String?
    let category_id: Int?
    let shop_id: Int?
    let sold: Int?
    let average_rating: Double?
    let rating_count: Int?
    let category: Category?
    let shop: Shop?
    let created_at: String?
    let updated_at: String?
    let ratings: [Rating]?
}
