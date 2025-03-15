//
//  TransactionService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//


struct TransactionService: Codable {
    let id: Int
    let order_service_id: Int
    let payment_status: String
    let payment_date: String
    let created_at: String
    let updated_at: String
}
