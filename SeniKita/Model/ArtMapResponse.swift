//
//  ArtMapResponse.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 10/03/25.
//

import Foundation

struct ArtMapResponse: Codable {
    let status: String
    let data: ArtMapData
}

struct ArtMapData: Codable {
    let artProvince: ArtProvince
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case artProvince = "art_province"
        case content
    }
}

struct ArtProvince: Codable {
    let id: Int
    let name: String
    let longitude: String
    let latitude: String
    let createdAt: String
    let updatedAt: String
    let subtitle: String
    let slug: String
    let artProvinceDetails: [ArtProvinceDetail]
    
    enum CodingKeys: String, CodingKey {
        case id, name, longitude, latitude, subtitle, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case artProvinceDetails = "art_province_details"
    }
}
