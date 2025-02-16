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

    enum CodingKeys: String, CodingKey {
        case id, name, longitude, latitude, subtitle, slug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)

        if let longitudeString = try container.decodeIfPresent(String.self, forKey: .longitude) {
            longitude = Double(longitudeString)
        } else {
            longitude = nil
        }

        if let latitudeString = try container.decodeIfPresent(String.self, forKey: .latitude) {
            latitude = Double(latitudeString)
        } else {
            latitude = nil
        }
    }
}
