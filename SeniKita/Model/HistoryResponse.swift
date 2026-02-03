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
    let address: Address?
    let product: [ProductWithPivot]?
    let transaction: Transaction?
}

extension OrderHistory {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        
        if let strValue = try? container.decode(String.self, forKey: .user_id) {
            user_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .user_id) {
            user_id = intValue
        } else {
            user_id = 0
        }
        
        email = try container.decode(String.self, forKey: .email)
        
        if let strValue = try? container.decode(String.self, forKey: .address_id) {
            address_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .address_id) {
            address_id = intValue
        } else {
            address_id = 0
        }
        
        no_transaction = try container.decode(String.self, forKey: .no_transaction)
        
        if let strValue = try? container.decode(String.self, forKey: .ongkir) {
            ongkir = Double(strValue) ?? 0.0
        } else if let doubleValue = try? container.decode(Double.self, forKey: .ongkir) {
            ongkir = doubleValue
        } else {
            ongkir = 0.0
        }
        
        if let strValue = try? container.decode(String.self, forKey: .price) {
            price = Double(strValue) ?? 0.0
        } else if let doubleValue = try? container.decode(Double.self, forKey: .price) {
            price = doubleValue
        } else {
            price = 0.0
        }
        
        if let strValue = try? container.decode(String.self, forKey: .total_price) {
            total_price = Double(strValue) ?? 0.0
        } else if let doubleValue = try? container.decode(Double.self, forKey: .total_price) {
            total_price = doubleValue
        } else {
            total_price = 0.0
        }
        
        courier = try container.decode(String.self, forKey: .courier)
        service = try container.decode(String.self, forKey: .service)
        invoice_url = try container.decode(String.self, forKey: .invoice_url)
        estimation = try container.decode(String.self, forKey: .estimation)
        status = try container.decode(String.self, forKey: .status)
        status_order = try container.decode(String.self, forKey: .status_order)
        note = try? container.decode(String.self, forKey: .note)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)
        address = try? container.decode(Address.self, forKey: .address)
        product = try? container.decode([ProductWithPivot].self, forKey: .product)
        transaction = try? container.decode(Transaction.self, forKey: .transaction)
    }
}
