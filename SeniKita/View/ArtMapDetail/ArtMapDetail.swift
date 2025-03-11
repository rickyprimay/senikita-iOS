//
//  ArtMapDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 10/03/25.
//

import SwiftUI
import AVFoundation

struct ArtMapDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var artMapViewModel: ArtMapViewModel
    
    var name: String
    var slug: String
    
    @State private var animatedText = ""
    @State private var isAnimating = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var timer: Timer?
    
    let fullText = "Jawa Timur, wah asyik! Daerahnya kaya banget sama wisata alam, Gunung Bromo dan Kawah Ijen contohnya, sejuk banget deh. Ada juga Reog Ponorogo, tariannya unik banget dengan singa besarnya yang gagah berani. Jangan lupa Karinding, alat musik bambu yang suaranya khas, walau asalnya Sunda, di Jawa Timur juga banyak kok! Terakhir, ada Taman Nasional Bromo Tengger Semeru, tempat menikmati matahari terbit yang spektakuler sambil belajar budaya suku Tengger. Seru banget kan?"
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Provinsi \(artMapViewModel.selectedArtMap?.name ?? "")")
                            .font(AppFont.Crimson.headerMedium)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text(artMapViewModel.selectedArtMap?.subtitle ?? "")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .padding(.bottom)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(animatedText)
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .topLeft, .bottomLeft]))
                        
                        HStack {
                            Spacer()
                            
                            Image("avatar")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(12)
                                .offset(y: isAnimating ? -10 : 10)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                                .onAppear {
                                    isAnimating = true
                                }
                        }
                        
                        Button(action: {
                            speakText()
                        }) {
                            HStack {
                                Text("Test")
                            }
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .onAppear {
                Task {
                    await artMapViewModel.fetchArtMapBySlug(slug: slug)
                }
            }
            .onDisappear {
                speechSynthesizer.stopSpeaking(at: .immediate)
                timer?.invalidate()
            }
            .onChange(of: artMapViewModel.isLoading) { isLoading in
                if !isLoading {
                    startTextAnimation()
                    speakText()
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(AppFont.Crimson.bodyLarge)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .tint(Color("tertiary"))
                }
                ToolbarItem(placement: .principal) {
                    Text(name)
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("tertiary"))
                }
            }
            if artMapViewModel.isLoading {
                Loading(opacity: 1)
            }
        }
    }
    
    private func startTextAnimation() {
        animatedText = ""
        let characters = Array(fullText)
        var index = 0

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            if index < characters.count {
                animatedText.append(characters[index])
                index += 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private func speakText() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.id-ID.Damayanti")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.2
        utterance.volume = 1.0

        speechSynthesizer.speak(utterance)
    }
}

