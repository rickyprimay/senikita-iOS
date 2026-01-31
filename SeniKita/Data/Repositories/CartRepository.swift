//
//  CartRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

struct CartOperationResponse: Codable {
    let status: String
    let message: String
}

final class CartRepository: CartRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func getCart() async throws -> [Cart] {
        let endpoint = CartEndpoint.list
        let response: CartResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to load cart")
        }
        
        return response.data
    }
    
    func getCartItems() async throws -> [Cart] {
        return try await getCart()
    }
    
    func addToCart(productId: Int, quantity: Int) async throws {
        let endpoint = CartEndpoint.addItem(productId: productId, quantity: quantity)
        let response: CartOperationResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func incrementItem(cartItemId: Int) async throws {
        let endpoint = CartEndpoint.increment(cartItemId: cartItemId)
        let response: CartOperationResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func decrementItem(cartItemId: Int) async throws {
        let endpoint = CartEndpoint.decrement(cartItemId: cartItemId)
        let response: CartOperationResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func removeItem(cartItemId: Int) async throws {
        let endpoint = CartEndpoint.removeItem(cartItemId: cartItemId)
        let response: CartOperationResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
}
