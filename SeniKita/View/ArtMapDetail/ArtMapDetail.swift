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
    
    @State private var isAnimating = false
    
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
                        Text(artMapViewModel.animatedText)
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .topLeft, .bottomLeft]))
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                CategoryButton(icon: "💃", text: "Tarian Tradisional")
                                CategoryButton(icon: "🎷", text: "Alat Musik Tradisional")
                                CategoryButton(icon: "🎊", text: "Festival Budaya")
                                CategoryButton(icon: "🥻", text: "Pakaian Adat")
                            }
                            
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
                            artMapViewModel.speakText(textUsing: fullText)
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
                    artMapViewModel.fetchArtMapBySlug(slug: slug)
                }
            }
            .onDisappear {
                artMapViewModel.speakText(textUsing: "")
            }
            
            .onChange(of: artMapViewModel.isLoading) {
                if !artMapViewModel.isLoading {
                    artMapViewModel.startTextAnimation(textUsing: fullText)
                    artMapViewModel.speakText(textUsing: fullText)
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
}
