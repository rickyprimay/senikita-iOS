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
    let status: Int?
    let thumbnail: String?
    let sold: Int?
    let person_amount: Int?
    let category_id: Int?
    let shop_id: Int?
    let average_rating: Double?
    let rating_count: Int?
    let created_at: String?
    let updated_at: String?
    let category: Category?
    let shop: Shop?
}
