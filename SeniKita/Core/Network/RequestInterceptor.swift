//
//  RequestInterceptor.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = SessionManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetry)
        }
        completion(.doNotRetry)
    }
}

class HeadersInterceptor: RequestInterceptor {
    private let commonHeaders: HTTPHeaders
    
    init(commonHeaders: [String: String]) {
        self.commonHeaders = HTTPHeaders(commonHeaders)
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        commonHeaders.forEach { header in
            if request.value(forHTTPHeaderField: header.name) == nil {
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        
        completion(.success(request))
    }
}
