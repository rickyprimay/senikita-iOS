//
//  AIEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

// MARK: - Request Models (inline for AI endpoints)

private struct GeminiRequest: Encodable {
    let contents: [Content]
    
    struct Content: Encodable {
        let parts: [Part]
        
        struct Part: Encodable {
            let text: String
        }
    }
}

private struct TTSRequest: Encodable {
    let text: String
    let model_id: String
    let voice_settings: VoiceSettings
    
    struct VoiceSettings: Encodable {
        let stability: Double
        let similarity_boost: Double
    }
}

// MARK: - AI Endpoints

enum AIEndpoint: Endpoint {
    case generateText(prompt: String, context: String)
    case textToSpeech(text: String, voiceId: String)
    
    var baseURL: String? {
        switch self {
        case .generateText:
            return AppConfig.ExternalAPI.geminiBaseURL
        case .textToSpeech:
            return AppConfig.ExternalAPI.elevenLabsBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .generateText:
            return ""
        case .textToSpeech(_, let voiceId):
            return "/\(voiceId)"
        }
    }
    
    var method: NetworkMethod {
        return .post
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .generateText:
            return ["key": AppConfig.ExternalAPI.geminiAPIKey]
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .textToSpeech:
            return [
                "xi-api-key": AppConfig.ExternalAPI.elevenLabsAPIKey,
                "Content-Type": "application/json"
            ]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .generateText(let prompt, let context):
            return GeminiRequest(contents: [
                GeminiRequest.Content(parts: [
                    GeminiRequest.Content.Part(text: "\(context)\n\nUser: \(prompt)")
                ])
            ])
        case .textToSpeech(let text, _):
            return TTSRequest(
                text: text,
                model_id: "eleven_monolingual_v1",
                voice_settings: TTSRequest.VoiceSettings(stability: 0.5, similarity_boost: 0.5)
            )
        }
    }
    
    var requiresAuth: Bool {
        return false
    }
}
