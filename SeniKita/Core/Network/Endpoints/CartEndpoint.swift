//
//  CartEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum CartEndpoint: Endpoint {
    case list
    case items
    case addItem(productId: Int, quantity: Int)
    case increment(cartItemId: Int)
    case decrement(cartItemId: Int)
    case removeItem(cartItemId: Int)
    
    var path: String {
        switch self {
        case .list:
            return "user/cart"
        case .items, .addItem:
            return "user/cart/items"
        case .increment(let cartItemId):
            return "user/cart/items/increment/\(cartItemId)"
        case .decrement(let cartItemId):
            return "user/cart/items/decrement/\(cartItemId)"
        case .removeItem(let cartItemId):
            return "user/cart/items/\(cartItemId)"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .list, .items:
            return .get
        case .addItem:
            return .post
        case .increment, .decrement:
            return .put
        case .removeItem:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .addItem(let productId, let quantity):
            return ["product_id": productId, "quantity": quantity]
        default:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        return true
    }
}
