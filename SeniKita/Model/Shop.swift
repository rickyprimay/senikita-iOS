//
//  Shop.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

struct Shop: Codable, Identifiable {
    let id: Int?
    let name: String?
    let desc: String?
    let address: String?
    let profile_picture: String?
    let status: Int?
    let balance: Int?
    let city_id: Int?
    let province_id: Int?
    let user_id: Int?
    let region: String?
    let city: City?
    let created_at: String?
    let updated_at: String?
}
