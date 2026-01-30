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

extension OrderServiceHistory {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        
        // Handle user_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .user_id) {
            user_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .user_id) {
            user_id = intValue
        } else {
            user_id = 0
        }
        
        // Handle service_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .service_id) {
            service_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .service_id) {
            service_id = intValue
        } else {
            service_id = 0
        }
        
        name = try container.decode(String.self, forKey: .name)
        
        // Handle qty as String or Int
        if let strValue = try? container.decode(String.self, forKey: .qty) {
            qty = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .qty) {
            qty = intValue
        } else {
            qty = 0
        }
        
        activity_name = try container.decode(String.self, forKey: .activity_name)
        activity_date = try container.decode(String.self, forKey: .activity_date)
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        activity_time = try container.decode(String.self, forKey: .activity_time)
        
        // Handle province_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .province_id) {
            province_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .province_id) {
            province_id = intValue
        } else {
            province_id = 0
        }
        
        // Handle city_id as String or Int
        if let strValue = try? container.decode(String.self, forKey: .city_id) {
            city_id = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .city_id) {
            city_id = intValue
        } else {
            city_id = 0
        }
        
        // Handle attendee as String or Int
        if let strValue = try? container.decode(String.self, forKey: .attendee) {
            attendee = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .attendee) {
            attendee = intValue
        } else {
            attendee = 0
        }
        
        no_transaction = try container.decode(String.self, forKey: .no_transaction)
        price = try container.decode(Double.self, forKey: .price)
        address = try container.decode(String.self, forKey: .address)
        description = try? container.decode(String.self, forKey: .description)
        invoice_url = try container.decode(String.self, forKey: .invoice_url)
        status = try container.decode(String.self, forKey: .status)
        status_order = try container.decode(String.self, forKey: .status_order)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)
        service = try container.decode(ServiceData.self, forKey: .service)
        transaction = try container.decode(TransactionService.self, forKey: .transaction)
    }
}

struct HistoryServiceResponseDetail: Codable {
    let status: String
    let message: String
    let data: OrderServiceDetailWrapper
}

struct OrderServiceDetailWrapper: Codable {
    let order: OrderServiceHistory
}

