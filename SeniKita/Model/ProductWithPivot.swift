//
//  ProductWithPivot.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//


struct ProductWithPivot: Codable {
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
    let created_at: String?
    let updated_at: String?
    let pivot: Pivot?
    let shop: Shop?
}

struct Pivot: Codable {
    let order_id: Int
    let product_id: Int
    let qty: Int
}

