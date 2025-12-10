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

extension ProductWithPivot {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        
        // Handle price as String or Int
        if let strValue = try? container.decode(String.self, forKey: .price) {
            price = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .price) {
            price = intValue
        } else {
            price = nil
        }
        
        desc = try? container.decode(String.self, forKey: .desc)
        
        // Handle stock as String or Int
        if let strValue = try? container.decode(String.self, forKey: .stock) {
            stock = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .stock) {
            stock = intValue
        } else {
            stock = nil
        }
        
        // Handle status as String or Int
        if let strValue = try? container.decode(String.self, forKey: .status) {
            status = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .status) {
            status = intValue
        } else {
            status = nil
        }
        
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
        
        // Handle category_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .category_id) {
            category_id = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .category_id) {
            category_id = intValue
        } else {
            category_id = nil
        }
        
        // Handle shop_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .shop_id) {
            shop_id = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .shop_id) {
            shop_id = intValue
        } else {
            shop_id = nil
        }
        
        // Handle sold as String or Int
        if let strValue = try? container.decode(String.self, forKey: .sold) {
            sold = Int(strValue)
        } else if let intValue = try? container.decode(Int.self, forKey: .sold) {
            sold = intValue
        } else {
            sold = nil
        }
        
        created_at = try? container.decode(String.self, forKey: .created_at)
        updated_at = try? container.decode(String.self, forKey: .updated_at)
        pivot = try? container.decode(Pivot.self, forKey: .pivot)
        shop = try? container.decode(Shop.self, forKey: .shop)
    }
}

struct Pivot: Codable {
    let order_id: Int
    let product_id: Int
    let qty: Int
}

extension Pivot {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Handle order_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .order_id) {
            order_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .order_id) {
            order_id = intValue
        } else {
            order_id = 0
        }
        
        // Handle product_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .product_id) {
            product_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .product_id) {
            product_id = intValue
        } else {
            product_id = 0
        }
        
        // Handle qty as String or Int
        if let strValue = try? container.decode(String.self, forKey: .qty) {
            qty = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .qty) {
            qty = intValue
        } else {
            qty = 0
        }
    }
}

