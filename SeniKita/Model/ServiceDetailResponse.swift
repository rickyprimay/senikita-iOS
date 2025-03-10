//
//  ServiceDetailResponse.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 10/03/25.
//

struct ServiceDetailResponse: Codable {
    let status: String
    let code: Int
    let message: String
    let service: ServiceData
}
