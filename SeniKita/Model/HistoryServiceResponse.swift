//
//  HistoryServiceResponse.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

import Foundation

struct HistoryServiceResponse: Codable {
    let status: String
    let message: String
    let data: [OrderServiceHistory]
}

struct OrderServiceHistory: Codable, Identifiable {
    let id: Int
    let user_id: Int
    let service_id: Int
    let name: String
    let qty: Int
    let activity_name: String
    let activity_date: String
    let phone: String
    let email: String
    let activity_time: String
    let province_id: Int
    let city_id: Int
    let attendee: Int
    let no_transaction: String
    let price: Double
    let address: String
    let description: String?
    let invoice_url: String
    let status: String
    let status_order: String
    let created_at: String
    let updated_at: String
    let service: ServiceData
    let transaction: TransactionService
}

struct HistoryServiceResponseDetail: Codable {
    let status: String
    let message: String
    let data: OrderServiceDetailWrapper
}

struct OrderServiceDetailWrapper: Codable {
    let order: OrderServiceHistory
}

