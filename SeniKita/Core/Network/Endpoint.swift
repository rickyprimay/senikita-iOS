//
//  Endpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import Alamofire

protocol Endpoint {
    var baseURL: String? { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: Encodable? { get }
    var parameters: [String: Any]? { get }
    var multipartFormData: ((MultipartFormData) -> Void)? { get }
    var requiresAuth: Bool { get }
}

extension Endpoint {
    var baseURL: String? { nil }
    var headers: [String: String]? { nil }
    var queryParameters: [String: String]? { nil }
    var body: Encodable? { nil }
    var parameters: [String: Any]? { nil }
    var multipartFormData: ((MultipartFormData) -> Void)? { nil }
    var requiresAuth: Bool { true }
}

public enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
