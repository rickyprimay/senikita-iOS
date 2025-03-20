//
//  Address.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//

struct SingleAddressResponse: Codable {
    let status: String
    let data: Address
}

struct AddressResponse: Codable {
    let status: String
    let data: [Address]
}

struct Address: Codable {
    let id: Int
    let user_id: Int
    let label_address: String
    let name: String
    let phone: String
    let address_detail: String
    let province_id: Int
    let city_id: Int
    let postal_code: Int
    let note: String?
    let created_at: String
    let updated_at: String
    let city: City?
    let province: Province?
}
