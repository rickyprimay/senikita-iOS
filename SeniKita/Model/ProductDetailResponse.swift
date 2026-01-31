//
//  ProductDetailResponse.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

struct ProductDetailResponse: Codable {
    let status: String
    let code: Int
    let message: String
    let product: ProductData
}
