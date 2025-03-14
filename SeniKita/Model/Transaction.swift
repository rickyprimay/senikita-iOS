//
//  Transaction.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//


struct Transaction: Codable {
    let id: Int
    let order_id: Int
    let payment_status: String
    let payment_date: String?
    let created_at: String
    let updated_at: String
}