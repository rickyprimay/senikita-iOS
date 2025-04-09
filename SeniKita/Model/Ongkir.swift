//
//  Ongkir.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 22/03/25.
//

struct OngkirResponse: Codable {
    let success: Bool
    let message: String
    let data: [Ongkir]
}

struct Ongkir: Codable {
    let service: String
    let description: String
    let cost: [Cost]
}

struct Cost: Codable {
    let value: Int
    let etd: String
    let note: String
}
