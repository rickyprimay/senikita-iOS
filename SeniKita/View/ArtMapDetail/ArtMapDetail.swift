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
    @Environment(\.isShowingTabBar) var isShowingTabBar
    @ObservedObject var artMapViewModel: ArtMapViewModel
    
    var name: String
    var slug: String
    
    @State var promptText: String = ""
    @State private var isAnimating = false
    @State private var selectedDetail: ArtProvinceDetail? = nil
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    heroSection
                    aiAssistantSection
                    culturalItemsSection
                }
                .padding(.bottom, 40)
            }
            
            if artMapViewModel.isLoading {
                Loading(opacity: 0.6)
            }
        }
        .onAppear {
            isShowingTabBar.wrappedValue = false
            artMapViewModel.fetchArtMapBySlug(slug: slug)
            if let firstDetail = artMapViewModel.selectedArtMap?.artProvinceDetails?.first {
                selectedDetail = firstDetail
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("primary"))
                }
            }
            ToolbarItem(placement: .principal) {
                Text(name)
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 12) {
            Text("Provinsi \(artMapViewModel.selectedArtMap?.name ?? name)")
                .font(AppFont.Nunito.headerMedium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(artMapViewModel.selectedArtMap?.subtitle ?? "Memuat informasi...")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.top, 16)
    }
    
    private var aiAssistantSection: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 12) {
                    aiResponseBubble
                    categoryButtons
                }
                
                Spacer()
                
                Image("avatar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 180)
                    .offset(y: isAnimating ? -6 : 6)
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
                        ) {
                            isAnimating = true
                        }
                    }
            }
            
            promptInputField
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        .padding(.horizontal, 16)
    }
    
    private var aiResponseBubble: some View {
        Group {
            if artMapViewModel.isSendingPrompt && artMapViewModel.animatedText.isEmpty {
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Sedang berpikir...")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Color("primary"))
                .cornerRadius(12)
            } else if !artMapViewModel.animatedText.isEmpty {
                Text(artMapViewModel.animatedText)
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color("primary"))
                    .cornerRadius(12)
                    .frame(maxWidth: 180, alignment: .leading)
            }
        }
    }
    
    private var categoryButtons: some View {
        VStack(alignment: .leading, spacing: 6) {
            CategoryChip(icon: "💃", text: "Tarian Tradisional") {
                promptText = "Tarian Tradisional di \(name)"
            }
            CategoryChip(icon: "🎷", text: "Alat Musik Tradisional") {
                promptText = "Alat Musik Tradisional di \(name)"
            }
            CategoryChip(icon: "🎊", text: "Festival Budaya") {
                promptText = "Festival Budaya di \(name)"
            }
            CategoryChip(icon: "🥻", text: "Pakaian Adat") {
                promptText = "Pakaian Adat di \(name)"
            }
        }
    }
    
    private var promptInputField: some View {
        HStack(spacing: 12) {
            TextField("Tanyakan tentang \(name)...", text: $promptText)
                .font(AppFont.Raleway.footnoteSmall)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(25)
            
            Button(action: {
                artMapViewModel.animatedText = ""
                artMapViewModel.sendPromptToGemini(prompt: promptText, statue: name)
            }) {
                ZStack {
                    Circle()
                        .fill(Color("primary"))
                        .frame(width: 44, height: 44)
                    
                    if artMapViewModel.isAnimatingText {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(artMapViewModel.isAnimatingText || promptText.isEmpty)
        }
    }
    
    private var culturalItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let details = artMapViewModel.selectedArtMap?.artProvinceDetails, !details.isEmpty {
                Text("Kesenian & Budaya")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                
                VStack(spacing: 12) {
                    ForEach(details) { detail in
                        let isSelected = selectedDetail?.id == detail.id
                        
                        ZStack(alignment: .bottomLeading) {
                            if let imageUrl = URL(string: detail.image) {
                                WebImage(url: imageUrl)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 100)
                                    .clipped()
                                    .overlay(
                                        LinearGradient(
                                            colors: [.clear, .black.opacity(0.6)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            } else {
                                Rectangle()
                                    .fill(Color(UIColor.systemGray4))
                                    .frame(height: 100)
                            }
                            
                            HStack {
                                Text(detail.name)
                                    .font(AppFont.Nunito.bodyMedium)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                                
                                Spacer()
                                
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(12)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color("primary") : .clear, lineWidth: 2)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if isSelected {
                                    selectedDetail = nil
                                } else {
                                    selectedDetail = detail
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                if let selected = selectedDetail {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(selected.name)
                                .font(AppFont.Nunito.subtitle)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    selectedDetail = nil
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(selected.description)
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                    .padding(.horizontal, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
}

struct CategoryChip: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(icon)
                    .font(.system(size: 12))
                Text(text)
                    .font(AppFont.Raleway.footnoteSmall)
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
        }
    }
}
