//
//  ServiceRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

final class ServiceRepository: ServiceRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func getServices() async throws -> [ServiceData] {
        let endpoint = ServiceEndpoint.list
        let response: ServiceResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data.data
    }
    
    func getServiceDetail(id: Int) async throws -> ServiceData {
        let endpoint = ServiceEndpoint.detail(id: id)
        let response: ServiceDetailResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.service
    }
}
