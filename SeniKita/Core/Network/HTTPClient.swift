//
//  HTTPClient.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import Alamofire

final class HTTPClient {
    static let shared = HTTPClient()
    
    private let session: Session
    private let decoder: JSONDecoder
    
    init() {
        self.decoder = JSONDecoder()
        
        let headersInterceptor = HeadersInterceptor(commonHeaders: [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Platform": "iOS"
        ])
        let authInterceptor = AuthInterceptor()
        let interceptor = Interceptor(interceptors: [headersInterceptor, authInterceptor])
        
        let monitors: [EventMonitor] = [SeniKitaLogger()]
        
        self.session = Session(interceptor: interceptor, eventMonitors: monitors)
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let request = try buildRequest(from: endpoint)
        
        let response = await session.request(request)
            .serializingData()
            .response
            
        try validateResponse(response)
        
        guard let data = response.data else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("[SeniKita] ========== Decoding Error ==========")
            print("[SeniKita] Type: \(T.self)")
            print("[SeniKita] Error: \(error)")
            if let json = String(data: data, encoding: .utf8) {
                print("[SeniKita] JSON: \(json.prefix(500))...")
            }
            throw NetworkError.decodingError(error)
        }
    }
    
    func requestRaw(endpoint: Endpoint) async throws -> Data {
        let request = try buildRequest(from: endpoint)
        
        let response = await session.request(request)
            .serializingData()
            .response
            
        try validateResponse(response)
        
        guard let data = response.data else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
    func request(endpoint: Endpoint) async throws {
        let request = try buildRequest(from: endpoint)
        
        let response = await session.request(request)
            .serializingData()
            .response
            
        try validateResponse(response)
    }
    
    func upload<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let baseURL = endpoint.baseURL ?? AppConfig.baseURL
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        guard let multipartFormData = endpoint.multipartFormData else {
            throw NetworkError.badRequest(nil)
        }
        
        var headers: HTTPHeaders = [:]
        endpoint.headers?.forEach { headers.add(name: $0.key, value: $0.value) }
        
        let method = Alamofire.HTTPMethod(rawValue: endpoint.method.rawValue)
        
        let response = await session.upload(multipartFormData: multipartFormData, to: url, method: method, headers: headers)
            .serializingData()
            .response
            
        try validateResponse(response)
        
        guard let data = response.data else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("[SeniKita] ========== Decoding Error ==========")
            print("[SeniKita] Type: \(T.self)")
            print("[SeniKita] Error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
    
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        let baseURL = endpoint.baseURL ?? AppConfig.baseURL
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30
        
        if let queryParams = endpoint.queryParameters, !queryParams.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            if let newURL = components?.url {
                request.url = newURL
            }
        }
        
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyToDict(body))
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.encodingError
            }
        } else if let parameters = endpoint.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.encodingError
            }
        }
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let afError = error as? AFError {
            switch afError {
            case .responseValidationFailed(let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    switch code {
                    case 400: return .badRequest(nil)
                    case 401: return .unauthorized
                    case 403: return .forbidden
                    case 404: return .notFound
                    case 500...599: return .serverErrorCode(statusCode: code)
                    default: return .unknown(statusCode: code)
                    }
                default: return .unknown(statusCode: -1)
                }
            case .sessionTaskFailed(let error):
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet: return .noInternetConnection
                    case .timedOut: return .timeout
                    default: return .unknown(statusCode: urlError.code.rawValue)
                    }
                }
            default: return .unknown(statusCode: -1)
            }
        }
        return .unknown(statusCode: -1)
    }
    
    private func validateResponse(_ response: DataResponse<Data, AFError>) throws {
        if let error = response.error {
            if response.response == nil {
                throw mapError(error)
            }
        }
        
        guard let httpResponse = response.response else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        
        if (200...299).contains(statusCode) {
            return
        }
        
        if let data = response.data, let body = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            let message = body["message"] as? String ?? body["error"] as? String
            
            print("[SeniKita] ========== Server Error ==========")
            print("[SeniKita] Status: \(statusCode)")
            print("[SeniKita] Body: \(body)")
            
            if statusCode == 422 {
                throw NetworkError.validationError(message: message ?? "Validasi gagal")
            } else if statusCode == 400 {
                throw NetworkError.badRequest(message)
            } else if statusCode == 401 {
                throw NetworkError.unauthorized
            } else if statusCode == 403 {
                throw NetworkError.forbidden
            } else if statusCode == 404 {
                throw NetworkError.notFound
            } else if statusCode >= 500 {
                 throw NetworkError.serverError(message ?? "Kesalahan server")
            }
        }
        
        throw mapError(response.error ?? AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode)))
    }

    private func bodyToDict(_ body: Encodable) -> [String: Any] {
        guard let data = try? JSONEncoder().encode(body) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] ?? [:]
    }
}

class SeniKitaLogger: EventMonitor, @unchecked Sendable {
    
    func requestDidResume(_ request: Request) {
        #if DEBUG
        guard let urlRequest = request.request else { return }
        
        print("")
        print("[SeniKita] ========== Info ==========")
        print("[SeniKita] 📤 REQUEST")
        print("[SeniKita] Method: \(urlRequest.httpMethod ?? "N/A")")
        print("[SeniKita] URL: \(urlRequest.url?.absoluteString ?? "N/A")")
        
        print("")
        print("[SeniKita] ========== Headers ==========")
        if let headers = urlRequest.allHTTPHeaderFields, !headers.isEmpty {
            var headersDict: [String: String] = [:]
            for (key, value) in headers {
                if key.lowercased() == "authorization" {
                    headersDict[key] = String(value.prefix(30)) + "..."
                } else {
                    headersDict[key] = value
                }
            }
            printJSON(headersDict)
        } else {
            print("[SeniKita] {}")
        }
        
        print("")
        print("[SeniKita] ========== Body ==========")
        if let body = urlRequest.httpBody {
            printJSONData(body)
        } else {
            print("[SeniKita] null")
        }
        print("")
        #endif
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        #if DEBUG
        logResponse(request: request, response: response.response, data: response.data as? Data, error: response.error, metrics: response.metrics)
        #endif
    }
    
    func request(_ request: DataRequest, didCompleteTask task: URLSessionTask, with result: AFResult<Data>) {
        #if DEBUG
        #endif
    }
    
    private func logResponse(request: Request, response: HTTPURLResponse?, data: Data?, error: AFError?, metrics: URLSessionTaskMetrics?) {
        let statusCode = response?.statusCode ?? 0
        let statusEmoji = (200...299).contains(statusCode) ? "✅" : "❌"
        
        print("")
        print("[SeniKita] ========== Info ==========")
        print("[SeniKita] \(statusEmoji) RESPONSE")
        print("[SeniKita] URL: \(request.request?.url?.absoluteString ?? "N/A")")
        print("[SeniKita] Method: \(request.request?.httpMethod ?? "N/A")")
        print("[SeniKita] Status: \(statusCode)")
        if let metrics = metrics {
            let duration = String(format: "%.2f", metrics.taskInterval.duration)
            print("[SeniKita] Duration: \(duration)s")
        }
        
        print("")
        print("[SeniKita] ========== Headers ==========")
        if let headers = response?.allHeaderFields as? [String: Any], !headers.isEmpty {
            var simpleHeaders: [String: String] = [:]
            for (key, value) in headers {
                simpleHeaders[String(describing: key)] = String(describing: value)
            }
            printJSON(simpleHeaders)
        } else {
            print("[SeniKita] {}")
        }
        
        print("")
        print("[SeniKita] ========== Response ==========")
        if let data = data {
            printJSONData(data, maxLength: 3000)
        } else {
            print("[SeniKita] null")
        }
        
        if let error = error {
            print("")
            print("[SeniKita] ========== Error ==========")
            print("[SeniKita] \(error.localizedDescription)")
        }
        print("")
    }
    
    private func printJSON(_ dict: [String: String]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                for line in jsonString.components(separatedBy: "\n") {
                    print("[SeniKita] \(line)")
                }
            }
        } catch {
            print("[SeniKita] \(dict)")
        }
    }
    
    private func printJSONData(_ data: Data, maxLength: Int = 2000) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                let truncated = prettyString.count > maxLength
                let output = truncated ? String(prettyString.prefix(maxLength)) : prettyString
                
                for line in output.components(separatedBy: "\n") {
                    print("[SeniKita] \(line)")
                }
                
                if truncated {
                    print("[SeniKita] ... (truncated, total: \(prettyString.count) chars)")
                }
            }
        } catch {
            if let str = String(data: data, encoding: .utf8) {
                print("[SeniKita] \(str.prefix(1000))")
            } else {
                print("[SeniKita] (binary data, \(data.count) bytes)")
            }
        }
    }
}
