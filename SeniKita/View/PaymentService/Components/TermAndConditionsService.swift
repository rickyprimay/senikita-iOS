//
//  TermAndConditionsService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/05/25.
//

import SwiftUI

struct TermAndConditionsService: View {
    
    @State private var isAgreed: Bool = false
    
    @Binding var currentStep: Int
    @Binding var isStepTwo: Bool
    @Binding var isStepThree: Bool
    
    var name: String
    var serviceId: Int
    var activityName: String
    var phone: Int
    var activityDate: Date
    var activityTime: Date
    var provinceId: Int
    var cityId: Int
    var address: String
    var attendee: Int
    var description: String
    
    @ObservedObject var paymentServiceViewModel: PaymentServiceViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Syarat & Ketentuan")
                    .font(AppFont.Nunito.titleMedium)
                    .bold()
                    .foregroundColor(.primary)
                
                Text("Baca dan setujui syarat ketentuan sebelum melanjutkan")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)
            
            // Terms Content Card
            termsCard
            
            // Agreement Toggle
            HStack(spacing: 12) {
                Toggle(isOn: $isAgreed) {
                    Text("Saya menyetujui syarat dan ketentuan yang berlaku.")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.primary)
                }
                .toggleStyle(CheckboxStyle())
            }
            .padding(.horizontal, 4)
            
            // Buttons
            HStack(spacing: 12) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isStepThree = false
                        isStepTwo = true
                        if currentStep == 3 {
                            self.currentStep -= 1
                        }
                    }
                } label: {
                    Text("Kembali")
                        .font(AppFont.Nunito.bodyMedium)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("secondary"))
                        .cornerRadius(12)
                }
                
                Button {
                    paymentServiceViewModel.payment(
                        name: name,
                        serviceId: serviceId,
                        activityName: activityName,
                        phone: phone,
                        activityDate: activityDate,
                        activityTime: activityTime,
                        province_id: provinceId,
                        city_id: cityId,
                        address: address,
                        attendee: attendee,
                        description: description
                    )
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Selesai")
                    }
                    .font(AppFont.Nunito.bodyMedium)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        isAgreed ?
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: isAgreed ? Color("primary").opacity(0.3) : .clear, radius: 8, y: 4)
                }
                .disabled(!isAgreed)
            }
        }
    }
    
    // MARK: - Terms Card
    private var termsCard: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                termItem("Platform Senikita menyediakan layanan untuk memesan pertunjukan seni dan membeli produk kesenian lokal. Senikita tidak bertanggung jawab atas kualitas, keamanan, atau ketersediaan layanan yang disediakan oleh pihak ketiga atau seniman yang terdaftar di platform.")
                
                termItem("Setiap pemesanan dianggap final setelah pembayaran berhasil diproses. Senikita berhak membatalkan pemesanan apabila terjadi ketidaksesuaian informasi atau pelanggaran terhadap ketentuan yang berlaku.")
                
                termItem("Pembayaran dapat dilakukan melalui metode pembayaran yang tersedia di platform. Kebijakan pengembalian dana berlaku dalam kondisi tertentu, seperti pembatalan layanan oleh penyedia atau ketidaksesuaian layanan yang diterima dengan yang dipesan.")
                
                termItem("Pengguna setuju untuk tidak menggunakan platform ini untuk kegiatan yang melanggar hukum atau merugikan pihak lain. Konten yang melanggar hak kekayaan intelektual atau bersifat diskriminatif dilarang.")
                
                termItem("Senikita berhak untuk mengubah, menambahkan, atau menghapus bagian dari Syarat dan Ketentuan ini kapan saja. Setiap perubahan akan diinformasikan melalui platform.")
                
                // Contact info
                HStack(spacing: 4) {
                    Text("Pertanyaan? Hubungi")
                        .font(AppFont.Raleway.footnoteLarge)
                        .foregroundColor(.gray)
                    Text("officialsenikita@gmail.com")
                        .font(AppFont.Raleway.footnoteLarge)
                        .foregroundColor(Color("primary"))
                }
                .padding(.top, 4)
            }
            .padding(16)
        }
        .frame(maxHeight: 280)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func termItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color("tertiary"))
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            Text(text)
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
