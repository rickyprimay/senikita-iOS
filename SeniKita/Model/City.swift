//
//  City.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//


struct City: Codable, Identifiable {
    let id: Int
    let province_id: Int?
    let type: String?
    let name: String?
    let postal_code: String?
    let province: Province?
    let created_at: String?
    let updated_at: String?
}