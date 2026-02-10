//
//  ArtMapViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import AVFoundation

@MainActor
class ArtMapViewModel: ObservableObject {
    
    private let artMapRepository: ArtMapRepositoryProtocol
    private let aiRepository: AIRepositoryProtocol
    
    @Published var artMap: [ArtMapResult] = []
    @Published var selectedArtMap: ArtMapResult?
    @Published var singleArtMap: ArtProvinceWrapper?
    @Published var isLoading: Bool = false
    @Published var animatedText = ""
    @Published var content: String? = nil
    @Published var isAnimatingText = false
    @Published var isSendingPrompt: Bool = false
    @Published var errorMessage: String = ""
    
    private var audioPlayer: AVAudioPlayer?
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init(
        artMapRepository: ArtMapRepositoryProtocol? = nil,
        aiRepository: AIRepositoryProtocol? = nil
    ) {
        let container = DIContainer.shared
        self.artMapRepository = artMapRepository ?? container.artMapRepository
        self.aiRepository = aiRepository ?? container.aiRepository
        
        fetchArtMap()
    }
    
    func fetchArtMap() {
        isLoading = true
        
        Task {
            do {
                let artMaps = try await artMapRepository.getArtMaps()
                self.artMap = artMaps
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func fetchArtMapBySlug(slug: String) {
        isLoading = true
        
        Task {
            do {
                let artMap = try await artMapRepository.getArtMapDetail(slug: slug)
                self.selectedArtMap = artMap
                self.content = artMap.subtitle
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func sendPromptToGemini(prompt: String, statue: String) {
        isSendingPrompt = true
        
        let context = "Anda adalah sistem yang memberikan pengetahuan tentang budaya dan kesenian. Jawablah setiap pertanyaan dengan ramah menggunakan bahasa Indonesia. Hindari sapaan dan jawaban yang terlalu panjang. Fokuslah pada jawaban yang informatif dan mudah dipahami. Jangan jawab pertanyaan jika tidak berkaitan dan berhubungan dengan seni dan budaya di indonesia terutama di wilayah \(statue). Jawab dengan jawaban yang friendly dan ramah bagi anak anak. Hindari sapaan dan jawaban panjang. Jawab hanya jika pertanyaan berkaitan dengan seni dan budaya Indonesia. Max 30 kata."
        
        Task {
            do {
                let text = try await aiRepository.sendPrompt(prompt: prompt, context: context)
                
                await self.speakText(textUsing: text)
                self.isSendingPrompt = false
                await self.startTextAnimation(textUsing: text)
            } catch {
                self.isSendingPrompt = false
                await self.startTextAnimation(textUsing: "Gagal menghasilkan konten. Coba lagi.")
            }
        }
    }
    
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
    
    func speakText(textUsing: String) async {
        do {
            let audioData = try await aiRepository.textToSpeech(text: textUsing)
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tts_audio_\(UUID().uuidString).mp3")
            try audioData.write(to: tempURL)
            
            DispatchQueue.main.async {
                self.audioPlayer = try? AVAudioPlayer(contentsOf: tempURL)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
            }
        } catch {
            print("Audio playback error: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.speakWithSystemTTS(text: textUsing)
            }
        }
    }
    
    private func speakWithSystemTTS(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        audioPlayer?.stop()
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}
