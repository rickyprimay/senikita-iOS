//
//  ArtMapRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol ArtMapRepositoryProtocol {
    func getArtMaps() async throws -> [ArtMapResult]
    func getArtMapDetail(slug: String) async throws -> ArtMapResult
}

// MARK: - AI Repository Protocol

protocol AIRepositoryProtocol {
    func sendPrompt(prompt: String, context: String) async throws -> String
    func textToSpeech(text: String) async throws -> Data
}
