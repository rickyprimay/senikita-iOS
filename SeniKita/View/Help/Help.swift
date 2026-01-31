//  Help.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

import SwiftUI

struct Help: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let steps: [(icon: String, title: String, description: String)] = [
        ("person.badge.plus", "Daftar sebagai Pengguna", "Buat akun dengan mengisi formulir pendaftaran. Setelah mendaftar, Anda dapat menjelajahi dan membeli berbagai produk dan jasa seni yang tersedia."),
        ("cart", "Pesan dan Pembayaran", "Setelah menemukan produk atau jasa yang diinginkan, klik tombol Beli Sekarang untuk melakukan pemesanan."),
        ("clock.badge.checkmark", "Tunggu Konfirmasi", "Setelah melakukan pembayaran, tunggu konfirmasi dari seniman. Kamu akan mendapatkan informasi lebih lanjut mengenai estimasi."),
        ("star.bubble", "Beri Ulasan", "Berikan ulasan dan penilaian tentang pengalamanmu setelah menerima produk atau jasa. Ulasan kamu akan membantu seniman lain."),
        ("paintbrush.pointed", "Menjadi Seniman", "Bergabunglah sebagai seniman dengan mendaftar di platform kami. Isi informasi mengenai karya seni dan layanan yang kamu tawarkan.")
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerCard
                    stepsSection
                }
                .padding(.bottom, 40)
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
                Text("Bantuan")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
            }
        }
        .hideTabBar()
    }
    
    private var headerCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            Text("Cara SeniKita Bekerja")
                .font(AppFont.Nunito.headerMedium)
                .foregroundColor(.white)
            
            Text("Panduan lengkap untuk pembeli dan seniman di platform kami")
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color("primary"), Color("primary").opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color("primary").opacity(0.3), radius: 12, y: 6)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var stepsSection: some View {
        VStack(spacing: 0) {
            ForEach(steps.indices, id: \.self) { index in
                StepCard(
                    step: steps[index],
                    stepNumber: index + 1,
                    isLastItem: index == steps.count - 1
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

struct StepCard: View {
    let step: (icon: String, title: String, description: String)
    let stepNumber: Int
    let isLastItem: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color("primary"))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: step.icon)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                if !isLastItem {
                    Rectangle()
                        .fill(Color("primary").opacity(0.2))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Langkah \(stepNumber)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color("primary"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("primary").opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                }
                
                Text(step.title)
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(.bottom, isLastItem ? 0 : 24)
        }
    }
}
