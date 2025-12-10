//
//  ArtMapDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 10/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtMapDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var artMapViewModel: ArtMapViewModel
    
    var name: String
    var slug: String
    
    @State var promptText: String = ""
    @State private var isAnimating = false
    @State private var selectedDetail: ArtProvinceDetail? = nil
    
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
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if artMapViewModel.isSendingPrompt && artMapViewModel.animatedText.isEmpty {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding()
                                .background(Color("primary"))
                                .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .topLeft, .bottomLeft]))
                        } else {
                            Text(artMapViewModel.animatedText)
                                .font(AppFont.Raleway.footnoteSmall)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("primary"))
                                .clipShape(RoundedCorner(radius: 12, corners: [.topRight, .topLeft, .bottomLeft]))
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                CategoryButton(icon: "💃", text: "Tarian Tradisional", action: {
                                    promptText = "Tarian Tradisional di \(name)"
                                })
                                CategoryButton(icon: "🎷", text: "Alat Musik Tradisional", action: {
                                    promptText = "Alat Musik Tradisional di \(name)"
                                })
                                CategoryButton(icon: "🎊", text: "Festival Budaya", action: {
                                    promptText = "Festival Budaya di \(name)"
                                })
                                CategoryButton(icon: "🥻", text: "Pakaian Adat", action: {
                                    promptText = "Pakaian Adat di \(name)"
                                })
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
                        
                        ZStack(alignment: .trailing) {
                            TextField("Tanyakan tentang \(name)", text: $promptText)
                                .font(AppFont.Raleway.footnoteSmall)
                                .foregroundColor(.black)
                                .padding(.trailing, 50)
                                .padding(.leading, 12)
                                .padding(.vertical, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            
                            Button(action: {
                                print("Button clicked, promptText: \(promptText), name: \(name)")
                                artMapViewModel.animatedText = ""
                                artMapViewModel.sendPromptToGemini(prompt: promptText, statue: name)
                            }) {
                                if artMapViewModel.isAnimatingText {
                                    ProgressView()
                                        .tint(.white)
                                        .padding(8)
                                        .background(Color("primary"))
                                        .clipShape(Circle())
                                        .padding(.trailing, 8)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color("primary"))
                                        .clipShape(Circle())
                                        .padding(.trailing, 8)
                                }
                            }
                            .disabled(artMapViewModel.isAnimatingText)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let details = artMapViewModel.selectedArtMap?.artProvinceDetails {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(details) { detail in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedDetail = (selectedDetail?.id == detail.id) ? nil : detail
                                    }
                                }) {
                                    ZStack {
                                        if let imageUrl = URL(string: detail.image) {
                                            WebImage(url: imageUrl)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity, maxHeight: selectedDetail?.id == detail.id ? 200 : 100)
                                                .clipped()
                                                .cornerRadius(12)
                                                .opacity(0.6)
                                                .overlay(
                                                    Color.black.opacity(selectedDetail?.id == detail.id ? 0.6 : 0.3)
                                                        .cornerRadius(12)
                                                )
                                        } else {
                                            Color.gray
                                                .frame(maxWidth: .infinity, maxHeight: 200)
                                                .cornerRadius(12)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            Text(detail.name)
                                                .font(AppFont.Crimson.bodyMedium)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .frame(maxWidth: .infinity)
                                            
                                            if selectedDetail?.id == detail.id {
                                                Text(detail.description)
                                                    .font(AppFont.Raleway.footnoteSmall)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .background(Color.black.opacity(0.5))
                                                    .cornerRadius(12)
                                            }
                                        }
                                        .padding()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .onAppear {
                Task {
                    artMapViewModel.fetchArtMapBySlug(slug: slug)
                    if let firstDetail = artMapViewModel.selectedArtMap?.artProvinceDetails?.first {
                        selectedDetail = firstDetail
                    }
                }
            }
            .onDisappear {
                Task {
                    await artMapViewModel.speakText(textUsing: "")
                }
            }
            
            .onChange(of: artMapViewModel.isLoading) {
                if !artMapViewModel.isLoading {
                    Task {
                        await artMapViewModel.startTextAnimation(textUsing: artMapViewModel.content ?? "")
                    }

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
