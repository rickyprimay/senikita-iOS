//
//  AppConfig.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum AppConfig {
    static var environment: AppEnvironment { .current }
  
    static var baseURL: String { environment.baseURL }
    static var webSocketHost: String { environment.webSocketHost }
    static var imageBaseURL: String { environment.imageBaseURL }
    
    static var geminiAPIKey: String { Secrets.geminiAPIKey }
    static var elevenLabsAPIKey: String { Secrets.elevenLabsAPIKey }
    
    enum ExternalAPI {
        static let geminiEndpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
        static let geminiBaseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
        static let geminiAPIKey = Secrets.geminiAPIKey
        static let elevenLabsVoiceID = "gmnazjXOFoOcWA59sd5m"
        static let elevenLabsBaseURL = "https://api.elevenlabs.io/v1/text-to-speech"
        static let elevenLabsAPIKey = Secrets.elevenLabsAPIKey
        
        static func elevenLabsTTSEndpoint(voiceID: String = elevenLabsVoiceID) -> String {
            "https://api.elevenlabs.io/v1/text-to-speech/\(voiceID)/stream"
        }
    }
    
    enum AppInfo {
        static let appName = "SeniKita"
        static let bundleID = Bundle.main.bundleIdentifier ?? "com.senikita.app"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
