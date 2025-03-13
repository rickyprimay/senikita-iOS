//
//  ArtMapViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation
import Alamofire
import AVFoundation
import GoogleGenerativeAI

class ArtMapViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: "AIzaSyCMZoLNkDoL6Gc-1Ae1gt8sIeBoqYkZBqM")
    
    @Published var artMap: [ArtMapResult] = []
    @Published var selectedArtMap: ArtMapResult?
    @Published var singleArtMap: ArtProvinceWrapper?
    @Published var isLoading: Bool = false
    @Published var animatedText = ""
    @Published var content: String? = nil
    @Published var isAnimatingText = false
    
    var errorMessage: String = ""
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init() {
        fetchArtMap()
    }
    
    func fetchArtMap() {
        isLoading = true
        guard let url = URL(string: baseUrl + "art-provinces") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        AF.request(url)
            .responseDecodable(of: ArtMapModel.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.artMap = result.data
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print(error)
                    }
                    self.isLoading = false
                }
            }
    }
    
    func fetchArtMapBySlug(slug: String) {
        isLoading = true
        guard let url = URL(string: baseUrl + "art-provinces/\(slug)") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        AF.request(url)
            .responseDecodable(of: SingleArtMapResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.selectedArtMap = result.data.artProvince
                        self.content = result.data.content
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print(error)
                    }
                    self.isLoading = false
                }
            }
    }
    
    func sendPromptToGemini(prompt: String, statue: String) {
        Task {
            do {
                let systemMessage = "Anda adalah sistem yang memberikan pengetahuan tentang budaya dan kesenian. Jawablah setiap pertanyaan dengan ramah menggunakan bahasa Indonesia. Hindari sapaan dan jawaban yang terlalu panjang. Fokuslah pada jawaban yang informatif dan mudah dipahami. Jangan jawab pertanyaan jika tidak berkaitan dan berhubungan dengan seni dan budaya di indonesia terutama di wilayah \(statue). Jawab dengan jawaban yang friendly dan ramah bagi anak anak."
                let response = try await model.generateContent(systemMessage + prompt)
                if let text = response.text {
                    await MainActor.run {
                        self.startTextAnimation(textUsing: text)
                        self.speakText(textUsing: text)
                    }
                }
            } catch {
                print("Error sending prompt to Gemini: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func startTextAnimation(textUsing: String) {
        guard !isAnimatingText else { return }
        animatedText = ""
        isAnimatingText = true

        let characters = Array(textUsing)
        Task {
            for char in characters {
                await MainActor.run { self.animatedText.append(char) }
                try? await Task.sleep(nanoseconds: 30_000_000)
            }
            isAnimatingText = false
        }
    }
    
    @MainActor
    func speakText(textUsing: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: textUsing)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.id-ID.Damayanti")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.2
        utterance.volume = 1.0
        
        speechSynthesizer.speak(utterance)
    }
}
