//
//  Rating.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

struct Rating: Codable, Identifiable {
    let id: Int
    let user_id: Int
    let product_id: Int
    let rating: Int
    let comment: String?
    let created_at: String?
    let updated_at: String?
    let user: User?
    let rating_images: [RatingImage]?
}
