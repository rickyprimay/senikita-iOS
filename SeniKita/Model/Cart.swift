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
    
    enum CodingKeys: String, CodingKey {
        case storeName, storeAvatar, storeLocation, productName, productThumbnail
        case productPrice, qty, shop_id, shop_city_id, product_id, cart_item_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        storeName = try container.decode(String.self, forKey: .storeName)
        storeAvatar = try container.decodeIfPresent(String.self, forKey: .storeAvatar)
        storeLocation = try container.decode(String.self, forKey: .storeLocation)
        productName = try container.decode(String.self, forKey: .productName)
        productThumbnail = try container.decode(String.self, forKey: .productThumbnail)
        
        if let priceDouble = try? container.decode(Double.self, forKey: .productPrice) {
            productPrice = priceDouble
        } else if let priceString = try? container.decode(String.self, forKey: .productPrice),
                  let price = Double(priceString) {
            productPrice = price
        } else {
            productPrice = 0
        }
        
        if let qtyInt = try? container.decode(Int.self, forKey: .qty) {
            qty = qtyInt
        } else if let qtyString = try? container.decode(String.self, forKey: .qty),
                  let qtyValue = Int(qtyString) {
            qty = qtyValue
        } else {
            qty = 0
        }
        
        if let shopIdInt = try? container.decode(Int.self, forKey: .shop_id) {
            shop_id = shopIdInt
        } else if let shopIdString = try? container.decode(String.self, forKey: .shop_id),
                  let shopIdValue = Int(shopIdString) {
            shop_id = shopIdValue
        } else {
            shop_id = 0
        }
        
        if let cityIdInt = try? container.decode(Int.self, forKey: .shop_city_id) {
            shop_city_id = cityIdInt
        } else if let cityIdString = try? container.decode(String.self, forKey: .shop_city_id),
                  let cityIdValue = Int(cityIdString) {
            shop_city_id = cityIdValue
        } else {
            shop_city_id = 0
        }
        
        if let productIdInt = try? container.decode(Int.self, forKey: .product_id) {
            product_id = productIdInt
        } else if let productIdString = try? container.decode(String.self, forKey: .product_id),
                  let productIdValue = Int(productIdString) {
            product_id = productIdValue
        } else {
            product_id = 0
        }
        
        if let cartItemIdInt = try? container.decode(Int.self, forKey: .cart_item_id) {
            cart_item_id = cartItemIdInt
        } else if let cartItemIdString = try? container.decode(String.self, forKey: .cart_item_id),
                  let cartItemIdValue = Int(cartItemIdString) {
            cart_item_id = cartItemIdValue
        } else {
            cart_item_id = 0
        }
    }
    
    init(storeName: String, storeAvatar: String?, storeLocation: String, productName: String, productThumbnail: String, productPrice: Double, qty: Int, shop_id: Int, shop_city_id: Int, product_id: Int, cart_item_id: Int) {
        self.storeName = storeName
        self.storeAvatar = storeAvatar
        self.storeLocation = storeLocation
        self.productName = productName
        self.productThumbnail = productThumbnail
        self.productPrice = productPrice
        self.qty = qty
        self.shop_id = shop_id
        self.shop_city_id = shop_city_id
        self.product_id = product_id
        self.cart_item_id = cart_item_id
    }
}
