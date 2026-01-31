//
//  ErrorResponse.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

struct ErrorResponse: Decodable {
    let status: String
    let message: String
    let code: Int
}
