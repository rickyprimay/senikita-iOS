//
//  ArtMapViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation
import Alamofire
import AVFoundation

class ArtMapViewModel: ObservableObject {
    
    let baseUrl = "https://senikita.sirekampolkesyogya.my.id/api/"
    let geminiApiKey = "AIzaSyBAzl_Ecc4T_7IHEdlz2rOuNNUj60OZLK8"
    
    @Published var artMap: [ArtMapResult] = []
    @Published var selectedArtMap: ArtMapResult?
    @Published var singleArtMap: ArtProvinceWrapper?
    @Published var isLoading: Bool = false
    @Published var animatedText = ""
    @Published var content: String? = nil
    @Published var isAnimatingText = false
    @Published var isSendingPrompt: Bool = false
    
    var errorMessage: String = ""
    private var audioPlayer: AVAudioPlayer?
    
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
            .validate()
            .responseData { raw in
                if let data = raw.data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("🔵 RAW RESPONSE:")
                    print(jsonString)
                } else {
                    print("⚠️ RAW RESPONSE: Empty or unreadable")
                }
            }
            .responseDecodable(of: SingleArtMapResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.selectedArtMap = result.data.artProvince
                        self.content = result.data.artProvince.subtitle
                        print("image from response \(result.data.artProvince.artProvinceDetails?.first?.image)")
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print("❌ Decoding error:", error)
                    }
                    
                    self.isLoading = false
                }
            }
    }
    
    func sendPromptToGemini(prompt: String, statue: String) {
        DispatchQueue.main.async {
            self.isSendingPrompt = true
        }
        print("Starting sendPromptToGemini with prompt: \(prompt), statue: \(statue)")
        let systemMessage = "Anda adalah sistem yang memberikan pengetahuan tentang budaya dan kesenian. Jawablah setiap pertanyaan dengan ramah menggunakan bahasa Indonesia. Hindari sapaan dan jawaban yang terlalu panjang. Fokuslah pada jawaban yang informatif dan mudah dipahami. Jangan jawab pertanyaan jika tidak berkaitan dan berhubungan dengan seni dan budaya di indonesia terutama di wilayah \(statue). Jawab dengan jawaban yang friendly dan ramah bagi anak anak. Hindari sapaan dan jawaban panjang. Jawab hanya jika pertanyaan berkaitan dengan seni dan budaya Indonesia. maksimal 20 word"
        let fullPrompt = systemMessage + prompt
        
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(geminiApiKey)"
        print("Endpoint: \(endpoint)")
        
        let parameters: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": fullPrompt]
                    ]
                ]
            ]
        ]
        print("Parameters: \(parameters)")
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .responseJSON { response in
                print("Response received: status \(response.response?.statusCode ?? 0)")
                if let statusCode = response.response?.statusCode, statusCode != 200 {
                    print("Non-200 status code: \(statusCode)")
                    if let data = response.data {
                        print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                    }
                    DispatchQueue.main.async {
                        Task {
                            await self.startTextAnimation(textUsing: "Gagal menghasilkan konten. Coba lagi.")
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        print("Gemini API Response: \(data)")
                        if let json = data as? [String: Any],
                           let candidates = json["candidates"] as? [[String: Any]],
                           let firstCandidate = candidates.first,
                           let content = firstCandidate["content"] as? [String: Any],
                           let parts = content["parts"] as? [[String: Any]],
                           let firstPart = parts.first,
                           let text = firstPart["text"] as? String {
                            Task {
                                await self.speakText(textUsing: text)
                                await self.startTextAnimation(textUsing: text)
                            }
                        } else {
                            print("Failed to parse response: \(data)")
                            Task {
                                await self.startTextAnimation(textUsing: "Gagal menghasilkan konten. Coba lagi.")
                            }
                        }
                    case .failure(let error):
                        print("Error sending prompt to Gemini: \(error.localizedDescription)")
                        if let data = response.data {
                            print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                        }
                        Task {
                            await self.startTextAnimation(textUsing: "Gagal menghasilkan konten. Coba lagi.")
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.isSendingPrompt = false
                }
            }
    }
    
    @MainActor
    func startTextAnimation(textUsing: String) async {
        guard !isAnimatingText else { return }
        animatedText = ""
        isAnimatingText = true
        
        let characters = Array(textUsing)
        for char in characters {
            animatedText.append(char)
            try? await Task.sleep(nanoseconds: 30_000_000)
        }
        isAnimatingText = false
    }
    
    @MainActor
    func speakText(textUsing: String) async {
        let apiKey = "sk_abbcc97ec9c3453e9eea3c595644f51634799caa3f4ab600"
        let voiceID = "gmnazjXOFoOcWA59sd5m"
        let url = "https://api.elevenlabs.io/v1/text-to-speech/\(voiceID)/stream"
        
        let headers: HTTPHeaders = [
            "xi-api-key": apiKey,
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "text": textUsing,
            "model_id": "eleven_multilingual_v2",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.7
            ]
            
        ]
        
        await withCheckedContinuation { continuation in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tts.mp3")
                        do {
                            try data.write(to: tempURL)
                            self.audioPlayer = try AVAudioPlayer(contentsOf: tempURL)
                            self.audioPlayer?.prepareToPlay()
                            self.audioPlayer?.play()
                            print("Audio started playing")
                            continuation.resume()
                        } catch {
                            print("Gagal memutar audio: \(error)")
                            continuation.resume()
                        }
                    case .failure(let error):
                        print("Streaming gagal: \(error.localizedDescription)")
                        continuation.resume()
                    }
                }
        }
    }
}
