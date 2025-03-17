//
//  Province.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

struct ProvinceResponse: Codable {
    let status: String
    let message: String
    let provinces: [Province]
}

struct Province: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let created_at: String?
    let updated_at: String?
}
