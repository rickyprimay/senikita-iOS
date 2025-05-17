//
//  TermAndConditionsService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/05/25.
//

import SwiftUI

struct TermAndConditionsService: View {
    
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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Text("Syarat & Ketentuan")
                        .font(AppFont.Crimson.titleMedium)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                Group {
                    Text("Dengan menggunakan platform Senikita, Anda menyetujui untuk mematuhi seluruh Syarat dan Ketentuan berikut:")
                    
                    Text("• Platform Senikita menyediakan layanan untuk memesan pertunjukan seni dan membeli produk kesenian lokal. Senikita tidak bertanggung jawab atas kualitas, keamanan, atau ketersediaan layanan yang disediakan oleh pihak ketiga atau seniman yang terdaftar di platform.")
                    
                    Text("• Setiap pemesanan dianggap final setelah pembayaran berhasil diproses. Senikita berhak membatalkan pemesanan apabila terjadi ketidaksesuaian informasi atau pelanggaran terhadap ketentuan yang berlaku.")
                    
                    Text("• Pembayaran dapat dilakukan melalui metode pembayaran yang tersedia di platform. Kebijakan pengembalian dana berlaku dalam kondisi tertentu, seperti pembatalan layanan oleh penyedia atau ketidaksesuaian layanan yang diterima dengan yang dipesan.")
                    
                    Text("• Pengguna setuju untuk tidak menggunakan platform ini untuk kegiatan yang melanggar hukum atau merugikan pihak lain. Konten yang melanggar hak kekayaan intelektual atau bersifat diskriminatif dilarang.")
                    
                    Text("• Senikita berhak untuk mengubah, menambahkan, atau menghapus bagian dari Syarat dan Ketentuan ini kapan saja. Setiap perubahan akan diinformasikan melalui platform.")
                    
                    Text("Jika Anda memiliki pertanyaan mengenai Syarat dan Ketentuan ini, silakan hubungi tim dukungan pelanggan kami melalui email: ")
                    +
                    Text("officialsenikita@gmail.com")
                        .foregroundColor(.blue)
                }
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.gray)
                
                Toggle(isOn: .constant(false)) {
                    Text("Saya menyetujui syarat dan ketentuan yang berlaku.")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.primary)
                }
                .toggleStyle(CheckboxStyle())
                
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                .background(Color(UIColor.systemBackground).cornerRadius(12))
        )
        .padding()
        
        HStack {
            Button{
                withAnimation {
                    isStepThree = false
                    isStepTwo = true
                    if currentStep == 3 {
                        self.currentStep -= 1
                    }
                }
            } label: {
                Text("Kembali")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("secondary"))
                    .cornerRadius(10)
            }
            Button{
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
                Text("Selesai")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primary"))
                    .cornerRadius(10)
            }
        }
    }
    
}
