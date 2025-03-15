//
//  HistoryResponse.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//

import Foundation

struct HistoryResponseDetail: Codable {
    let status: String
    let message: String
    let data: OrderDetailWrapper
}

struct OrderDetailWrapper: Codable {
    let order: OrderHistory
}

struct HistoryResponse: Codable {
    let status: String
    let message: String
    let data: [OrderHistory]
}

struct OrderHistory: Codable, Identifiable {
    let id: Int
    let user_id: Int
    let email: String
    let address_id: Int
    let no_transaction: String
    let ongkir: Double
    let price: Double
    let total_price: Double
    let courier: String
    let service: String
    let invoice_url: String
    let estimation: String
    let status: String
    let status_order: String
    let note: String?
    let created_at: String
    let updated_at: String
    let address: Address
    let product: [ProductWithPivot]
    let transaction: Transaction?
}
