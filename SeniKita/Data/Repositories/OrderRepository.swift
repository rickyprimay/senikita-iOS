//
//  OrderRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

struct OrderOperationResponse: Codable {
    let status: String
    let message: String
}

struct CheckoutData: Codable {
    let order: OrderHistory
}

struct CheckoutOrderResponse: Codable {
    let status: String
    let message: String
    let data: CheckoutData?
}

struct SingleOrderResponse: Codable {
    let status: String
    let message: String
    let data: OrderDetailWrapper
}

struct ServiceOrderWrapper: Codable {
    let order: OrderServiceHistory
}

struct ServiceCheckoutResponse: Codable {
    let status: String
    let message: String
    let data: ServiceOrderWrapper?
}

final class OrderRepository: OrderRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func checkout(
        addressId: Int,
        shippingService: String,
        productIds: [Int],
        qtys: [Int]
    ) async throws -> OrderHistory {
        let endpoint = OrderEndpoint.checkout(
            addressId: addressId,
            shippingService: shippingService,
            productIds: productIds,
            qtys: qtys
        )
        let response: CheckoutOrderResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let data = response.data else {
            throw NetworkError.serverError(response.message)
        }
        
        return data.order
    }
    
    func getOrderHistory() async throws -> [OrderHistory] {
        let endpoint = OrderEndpoint.history
        let response: HistoryResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data
    }
    
    func getOrderDetail(id: Int) async throws -> OrderHistory {
        let endpoint = OrderEndpoint.historyDetail(id: id)
        let response: HistoryResponseDetail = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data.order
    }
    
    func cancelOrder(id: Int) async throws {
        let endpoint = OrderEndpoint.cancelOrder(id: id)
        let response: OrderOperationResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func confirmOrder(id: Int) async throws {
        let endpoint = OrderEndpoint.confirmOrder(id: id)
        let response: OrderOperationResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func submitRating(
        transactionId: Int,
        productId: Int,
        rating: Int,
        review: String,
        images: [Data]?
    ) async throws {
        let endpoint = OrderEndpoint.submitRating(
            transactionId: transactionId,
            productId: productId,
            rating: rating,
            review: review,
            images: images
        )
        let response: OrderOperationResponse = try await client.upload(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func submitServiceRating(
        transactionId: Int,
        serviceId: Int,
        rating: Int,
        review: String,
        images: [Data]?
    ) async throws {
        let endpoint = OrderEndpoint.submitServiceRating(
            transactionId: transactionId,
            serviceId: serviceId,
            rating: rating,
            review: review,
            images: images
        )
        let response: OrderOperationResponse = try await client.upload(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
    }
    
    func checkoutService(
        name: String,
        serviceId: Int,
        activityName: String,
        phone: String,
        activityDate: String,
        activityTime: String,
        provinceId: Int,
        cityId: Int,
        address: String,
        attendee: Int,
        description: String
    ) async throws -> OrderServiceHistory {
        let endpoint = OrderEndpoint.checkoutService(
            name: name,
            serviceId: serviceId,
            activityName: activityName,
            phone: phone,
            activityDate: activityDate,
            activityTime: activityTime,
            provinceId: provinceId,
            cityId: cityId,
            address: address,
            attendee: attendee,
            description: description
        )
        let response: ServiceCheckoutResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success", let data = response.data else {
            throw NetworkError.serverError(response.message)
        }
        
        return data.order
    }
    
    func getServiceOrderHistory() async throws -> [OrderServiceHistory] {
        let endpoint = OrderEndpoint.serviceHistory
        let response: HistoryServiceResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data
    }
    
    func getServiceOrderDetail(id: Int) async throws -> OrderServiceHistory {
        let endpoint = OrderEndpoint.serviceHistoryDetail(id: id)
        let response: HistoryServiceResponseDetail = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data.order
    }
    
    func checkShippingCost(
        origin: Int,
        destination: Int,
        weight: Int,
        courier: String
    ) async throws -> [Ongkir] {
        let endpoint = OrderEndpoint.checkOngkir(
            origin: origin,
            destination: destination,
            weight: weight,
            courier: courier
        )
        let response: OngkirResponse = try await client.request(endpoint: endpoint)
        
        guard response.success else {
            throw NetworkError.serverError(response.message)
        }
        
        return response.data
    }
}
