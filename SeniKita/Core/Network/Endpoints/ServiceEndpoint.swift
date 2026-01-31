//
//  ServiceEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum ServiceEndpoint: Endpoint {
    case list
    case detail(id: Int)
    case search(query: String)
    
    var path: String {
        switch self {
        case .list:
            return "service"
        case .detail(let id):
            return "service/\(id)"
        case .search(let query):
            return "service?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        }
    }
    
    var method: NetworkMethod {
        return .get
    }
}
