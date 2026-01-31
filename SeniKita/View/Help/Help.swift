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
        ("light.recessed.3.inverse", "Beri Ulasan", "Berikan ulasan dan penilaian tentang pengalamanmu setelah menerima produk atau jasa. Ulasan kamu akan membantu seniman lain dan meningkatkan kredibilitas di platform."),
        ("star.fill", "Menjadi Seniman", "Bergabunglah sebagai seniman dengan mendaftar di platform kami. Isi informasi mengenai karya seni dan layanan yang kamu tawarkan untuk mulai menjual.")
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        VStack(spacing: 8) {
                            Text("Cara Senikita Bekerja untuk Pembeli")
                                .font(AppFont.Crimson.headerMedium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            Text("Jelajahi, pilih layanan atau produk seni, dan lakukan transaksi dengan mudah di satu platform.")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color("tertiary"), Color("primary")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.bottom, 24)

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(steps.indices, id: \.self) { index in
                                SupportStep(
                                    step: steps[index],
                                    isLastItem: index == steps.count - 1
                                )
                            }
                        }

                    }
                    .padding(.bottom, 32)
                }
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(AppFont.Raleway.bodyLarge)
                                .frame(width: 40, height: 40)
                                .background(Color.brown.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .tint(Color("tertiary"))
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Support & Bantuan")
                            .font(AppFont.Raleway.bodyLarge)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                }
            }
        }
        .hideTabBar()
    }
}
