//
//  ProductRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

final class ProductRepository: ProductRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func getProducts() async throws -> [ProductData] {
        let endpoint = ProductEndpoint.list
        let response: Product = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data.data
    }
    
    func getProductDetail(id: Int) async throws -> ProductData {
        let endpoint = ProductEndpoint.detail(id: id)
        let response: ProductDetailResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.product
    }
    
    func getProductsByCategory(categoryId: Int) async throws -> [ProductData] {
        let endpoint = ProductEndpoint.byCategory(categoryId: categoryId)
        let response: Product = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data.data
    }
    
    func searchProducts(query: String) async throws -> [ProductData] {
        let endpoint = ProductEndpoint.search(query: query)
        let response: Product = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data.data
    }
}
