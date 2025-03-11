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
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var artMap: [ArtMapResult] = []
    @Published var selectedArtMap: ArtMapResult?
    @Published var singleArtMap: ArtProvinceWrapper?
    @Published var isLoading: Bool = false
    @Published var animatedText = ""

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
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print(error)
                    }
                    self.isLoading = false
                }
            }
    }

    func startTextAnimation(textUsing: String) {
        animatedText = ""
        let characters = Array(textUsing)
        Task {
            for char in characters {
                await MainActor.run { self.animatedText.append(char) }
                try? await Task.sleep(nanoseconds: 30_000_000)
            }
        }
    }
    
    func speakText(textUsing: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.speechSynthesizer.isSpeaking {
                self.speechSynthesizer.stopSpeaking(at: .immediate)
            }

            let utterance = AVSpeechUtterance(string: textUsing)
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.id-ID.Damayanti")
            utterance.rate = 0.45
            utterance.pitchMultiplier = 1.2
            utterance.volume = 1.0

            self.speechSynthesizer.speak(utterance)
        }
    }
}
