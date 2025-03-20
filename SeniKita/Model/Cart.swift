//
//  Cart.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 19/03/25.
//

import Foundation

struct CartResponse: Codable {
    let status: String
    let data: [Cart]
}

struct Cart: Codable {
    let storeName: String
    let storeAvatar: String?
    let storeLocation: String
    let productName: String
    let productThumbnail: String
    let productPrice: Double
    var qty: Int
    let shop_id: Int
    let shop_city_id: Int
    let product_id: Int
    let cart_item_id: Int
}
