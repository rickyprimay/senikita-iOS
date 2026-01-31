//
//  ProductEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum ProductEndpoint: Endpoint {
    case list
    case detail(id: Int)
    case byCategory(categoryId: Int)
    case search(query: String)
    
    var path: String {
        switch self {
        case .list:
            return "products"
        case .detail(let id):
            return "products/\(id)"
        case .byCategory(let categoryId):
            return "products/category/\(categoryId)"
        case .search(let query):
            return "products?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        }
    }
    
    var method: NetworkMethod {
        return .get
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
}
