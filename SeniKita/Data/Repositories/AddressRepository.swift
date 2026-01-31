//
//  AddressRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

struct DeleteResponse: Codable {
    let status: String
    let message: String
}

final class AddressRepository: AddressRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func getAddresses() async throws -> [Address] {
        let endpoint = AddressEndpoint.list
        let response: AddressResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to load addresses")
        }
        
        return response.data
    }
    
    func getAddressDetail(id: Int) async throws -> Address {
        let endpoint = AddressEndpoint.detail(id: id)
        let response: SingleAddressResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to load address detail")
        }
        
        return response.data
    }
    
    func createAddress(
        name: String,
        phone: String,
        provinceId: Int,
        cityId: Int,
        address: String,
        postalCode: String,
        note: String?,
        isDefault: Bool
    ) async throws -> Address {
        let endpoint = AddressEndpoint.create(
            name: name,
            phone: phone,
            provinceId: provinceId,
            cityId: cityId,
            address: address,
            postalCode: postalCode,
            note: note,
            isDefault: isDefault
        )
        let response: SingleAddressResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to create address")
        }
        
        return response.data
    }
    
    func updateAddress(
        id: Int,
        name: String,
        phone: String,
        provinceId: Int,
        cityId: Int,
        address: String,
        postalCode: String,
        note: String?,
        isDefault: Bool
    ) async throws -> Address {
        let endpoint = AddressEndpoint.update(
            id: id,
            name: name,
            phone: phone,
            provinceId: provinceId,
            cityId: cityId,
            address: address,
            postalCode: postalCode,
            note: note,
            isDefault: isDefault
        )
        let response: SingleAddressResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to update address")
        }
        
        return response.data
    }
    
    func deleteAddress(id: Int) async throws {
        let endpoint = AddressEndpoint.delete(id: id)
        let response: DeleteResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func getCities() async throws -> [City] {
        let endpoint = AddressEndpoint.cities
        let response: CityResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.cities
    }
    
    func getProvinces() async throws -> [Province] {
        let endpoint = AddressEndpoint.provinces
        let response: ProvinceResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.provinces
    }
    
    func getCitiesByProvince(provinceId: Int) async throws -> [City] {
        let endpoint = AddressEndpoint.citiesByProvince(provinceId: provinceId)
        let response: CityResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.cities
    }
}
