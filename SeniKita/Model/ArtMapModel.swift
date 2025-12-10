//
//  ArtMapModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

struct ArtMapModel: Codable {
    let data: [ArtMapResult]
}

struct ArtMapResult: Codable, Identifiable {
    let id: Int
    let name: String?
    let longitude: Double?
    let latitude: Double?
    let subtitle: String?
    let slug: String?
    let artProvinceDetails: [ArtProvinceDetail]?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case id, name, longitude, latitude, subtitle, slug, content
        case artProvinceDetails = "art_province_details"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
        content = try container.decodeIfPresent(String.self, forKey: .content)

        if let longitudeValue = try? container.decode(Double.self, forKey: .longitude) {
            longitude = longitudeValue
        } else if let longitudeString = try? container.decode(String.self, forKey: .longitude) {
            longitude = Double(longitudeString)
        } else {
            longitude = nil
        }

        if let latitudeValue = try? container.decode(Double.self, forKey: .latitude) {
            latitude = latitudeValue
        } else if let latitudeString = try? container.decode(String.self, forKey: .latitude) {
            latitude = Double(latitudeString)
        } else {
            latitude = nil
        }

        artProvinceDetails = try container.decodeIfPresent([ArtProvinceDetail].self, forKey: .artProvinceDetails)
    }
}

struct SingleArtMapResponse: Codable {
    let status: String
    let data: ArtProvinceWrapper
}

struct ArtProvinceWrapper: Codable {
    let artProvince: ArtMapResult
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case content
        case artProvince = "art_province"
    }
}


struct ArtProvinceDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let type: String
    let artProvinceID: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, type, description
        case artProvinceID = "art_province_id"
    }
}

extension ArtProvinceDetail {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decode(String.self, forKey: .description)
        
        if let strValue = try? container.decode(String.self, forKey: .artProvinceID) {
            artProvinceID = Int(strValue) ?? 0
        } else if let intValue = try? container.decode(Int.self, forKey: .artProvinceID) {
            artProvinceID = intValue
        } else {
            artProvinceID = 0
        }
    }
}
