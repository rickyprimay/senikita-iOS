//
//  RatingImage.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

struct RatingImage: Codable, Identifiable {
    let id: Int
    let rating_product_id: Int
    let picture_rating_product: String
    let created_at: String?
    let updated_at: String?
}
