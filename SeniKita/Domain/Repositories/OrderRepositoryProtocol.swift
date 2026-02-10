//
//  OrderRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol OrderRepositoryProtocol {
    func checkout(
        addressId: Int,
        shippingService: String,
        productIds: [Int],
        qtys: [Int]
    ) async throws -> OrderHistory
    
    func getOrderHistory() async throws -> [OrderHistory]
    func getOrderDetail(id: Int) async throws -> OrderHistory
    func cancelOrder(id: Int) async throws
    func confirmOrder(id: Int) async throws
    
    func submitRating(
        transactionId: Int,
        productId: Int,
        rating: Int,
        review: String,
        images: [Data]?
    ) async throws
    
    func submitServiceRating(
        transactionId: Int,
        serviceId: Int,
        rating: Int,
        review: String,
        images: [Data]?
    ) async throws
    
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
    ) async throws -> OrderServiceHistory
    
    func getServiceOrderHistory() async throws -> [OrderServiceHistory]
    func getServiceOrderDetail(id: Int) async throws -> OrderServiceHistory
    
    func markProductAsReceived(id: Int) async throws
    func markServiceAsReceived(id: Int) async throws
    
    func checkShippingCost(
        origin: Int,
        destination: Int,
        weight: Int,
        courier: String
    ) async throws -> [Ongkir]
}
