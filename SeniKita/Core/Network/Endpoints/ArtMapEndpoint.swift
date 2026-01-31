//
//  ArtMapEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum ArtMapEndpoint: Endpoint {
    case list
    case detail(slug: String)
    
    var path: String {
        switch self {
        case .list:
            return "art-provinces"
        case .detail(let slug):
            return "art-provinces/\(slug)"
        }
    }
    
    var method: NetworkMethod {
        return .get
    }
}
