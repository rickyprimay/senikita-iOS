//
//  ArtMapRepository.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

struct ArtMapListResponse: Codable {
    let status: String
    let data: [ArtMapResult]
}

struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]?
}

struct GeminiCandidate: Codable {
    let content: GeminiContent?
}

struct GeminiContent: Codable {
    let parts: [GeminiPart]?
}

struct GeminiPart: Codable {
    let text: String?
}

final class ArtMapRepository: ArtMapRepositoryProtocol {
    private let client = HTTPClient.shared
    
    init() {}
    
    func getArtMaps() async throws -> [ArtMapResult] {
        let endpoint = ArtMapEndpoint.list
        let response: ArtMapListResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to load art maps")
        }
        
        return response.data
    }
    
    func getArtMapDetail(slug: String) async throws -> ArtMapResult {
        let endpoint = ArtMapEndpoint.detail(slug: slug)
        let response: SingleArtMapResponse = try await client.request(endpoint: endpoint)
        
        guard response.status == "success" else {
            throw NetworkError.serverError("Failed to load art map detail")
        }
        
        var result = response.data.artProvince
        return ArtMapResult(
            id: result.id,
            name: result.name,
            longitude: result.longitude,
            latitude: result.latitude,
            subtitle: result.subtitle,
            slug: result.slug,
            artProvinceDetails: result.artProvinceDetails,
            content: response.data.content
        )
    }
}

final class AIRepository: AIRepositoryProtocol {
    private let client = HTTPClient.shared
    
    func sendPrompt(prompt: String, context: String) async throws -> String {
        let endpoint = AIEndpoint.generateText(prompt: prompt, context: context)
        let response: GeminiResponse = try await client.request(endpoint: endpoint)
        
        guard let text = response.candidates?.first?.content?.parts?.first?.text else {
            throw NetworkError.decodingFailed
        }
        
        return text
    }
    
    func textToSpeech(text: String) async throws -> Data {
        let voiceId = "21m00Tcm4TlvDq8ikWAM"
        let endpoint = AIEndpoint.textToSpeech(text: text, voiceId: voiceId)
        return try await client.requestRaw(endpoint: endpoint)
    }
}
