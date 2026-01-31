//
//  Environment.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum AppEnvironment: String {
    case production
    
    private static let baseHost = "senikita.sirekampolkesyogya.my.id"
    
    var baseURL: String {
        "https://\(Self.baseHost)/api/"
    }
    
    var webSocketHost: String {
        Self.baseHost
    }
    
    var imageBaseURL: String {
        "https://\(Self.baseHost)/storage/"
    }
    
    static var current: AppEnvironment {
        .production
    }
}
