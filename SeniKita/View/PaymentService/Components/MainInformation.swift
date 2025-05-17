//
//  MainInformation.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/05/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainInformation: View {
    var imageService: String?
    var nameShop: String?
    var nameService: String?
    var price: Double?
    @Binding var currentStep: Int
    @Binding var namePIC: String
    @Binding var callNumber: String
    @Binding var eventName: String
    @Binding var eventDate: Date
    @Binding var eventTime: Date
    
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var showProvinceDropdown = false
    @State private var showCityDropdown = false

    @State private var selectedProvince: Province?
    @State private var selectedCity: City?

    @StateObject private var addressViewModel = AddressViewModel()

    @Binding var eventLocation: String
    @Binding var attendee: String
    @Binding var isStepTwo: Bool

    var isFormComplete: Bool {
        return !namePIC.isEmpty && !callNumber.isEmpty && !eventName.isEmpty && !eventLocation.isEmpty && selectedProvince != nil && selectedCity != nil
    }
    
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = URL(string: imageService ?? "") {
                WebImage(url: imageUrl)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            } else {
                Color.gray
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(nameShop ?? "")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundStyle(Color("tertiary"))
                Text(nameService ?? "")
                    .font(AppFont.Raleway.bodyLarge)
                    .foregroundColor(.black)
                Text("\(price?.formatPrice() ?? "0")")
                    .font(AppFont.Raleway.bodyMedium)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.bottom)
        
        VStack(spacing: 12) {
            CustomInputField(
                title: "Nama Penanggungjawab",
                tip: "Masukkan nama lengkap penanggung jawab acara/kegiatan.",
                placeholder: "Masukkan nama penanggungjawab",
                text: $namePIC
            )
            
            CustomInputField(
                title: "Nomor Telepon",
                tip: "Gunakan nomor telepon yang bisa dihubungi. Pastikan nomor telepon yang Anda masukkan benar dan aktif.",
                placeholder: "Masukkan nomor telepon",
                text: $callNumber,
                keyboardType: .phonePad
            )
            
            CustomInputField(
                title: "Nama Acara/Kegiatan",
                tip: "Gunakan nama acara yang jelas dan singkat. Misalnya, 'Pernikahan Budi & Ani' atau 'Festival Budaya Kertanegara'.",
                placeholder: "Masukkan nama acara/kegiatan",
                text: $eventName
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tanggal Acara")
                    .font(AppFont.Nunito.bodyLarge)
                    .bold()
                
                Text("Tip: Pilih tanggal yang sesuai dengan hari penyelenggaraan acara Anda. Pastikan tidak ada kesalahan pada tanggal, terutama jika acara melibatkan banyak orang.")
                    .font(AppFont.Nunito.footnoteLarge)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }) {
                    Text(dateFormatter.string(from: eventDate))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("tertiary"), lineWidth: 2))
                }
                
                if showDatePicker {
                    VStack {
                        DatePicker("", selection: $eventDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("tertiary"), lineWidth: 2))
                        
                        Button("Submit") {
                            withAnimation {
                                showDatePicker = false
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("primary"), Color("tertiary")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Waktu Acara")
                    .font(AppFont.Raleway.bodyLarge)
                    .bold()
                
                Text("Tip: Masukkan waktu dimulainya acara dengan format 24 jam (misalnya, 18:00 untuk jam 6 sore).")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    withAnimation {
                        showTimePicker.toggle()
                    }
                }) {
                    Text(timeFormatter.string(from: eventTime))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("tertiary"), lineWidth: 2))
                }
                
                if showTimePicker {
                    VStack {
                        DatePicker("", selection: $eventTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("tertiary"), lineWidth: 2))
                        
                        Button("Submit") {
                            withAnimation {
                                showTimePicker = false
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("primary"), Color("tertiary")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            
            CustomTextAreaField(
                title: "Lokasi Acara",
                tip: "Masukkan alamat lengkap acara, termasuk nama jalan, nomor, kelurahan, dan kecamatan. Tambahkan patokan atau arah tambahan jika diperlukan.",
                placeholder: "Masukkan alamat lengkap acara",
                text: $eventLocation
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Provinsi")
                    .font(.footnote)
                    .foregroundColor(.black)
                
                Text("Tip: Pilih provinsi tempat acara akan diselenggarakan")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    withAnimation {
                        showProvinceDropdown.toggle()
                        if showProvinceDropdown {
                            addressViewModel.getProvinces()
                        }
                    }
                }) {
                    HStack {
                        Text(selectedProvince?.name ?? "Pilih Provinsi")
                            .foregroundColor(selectedProvince == nil ? .gray : .black)
                        Spacer()
                        Image(systemName: showProvinceDropdown ? "chevron.up" : "chevron.down")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("tertiary"), lineWidth: 2))
                }
                
                if showProvinceDropdown && !addressViewModel.province.isEmpty {
                    VStack {
                        ScrollView {
                            ForEach(addressViewModel.province, id: \.id) { province in
                                Button(action: {
                                    selectedProvince = province
                                    selectedCity = nil
                                    showProvinceDropdown = false
                                    addressViewModel.getCitiesByIdProvinces(idProvinces: province.id) {
                                    }
                                }) {
                                    Text(province.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .foregroundColor(.black)
                                }
                                Divider()
                            }
                        }
                        .frame(maxHeight: 200)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            
            if selectedProvince != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Kota/Kabupaten")
                        .font(.footnote)
                        .foregroundColor(.black)
                    
                    Text("Tip: Pilih kota/kabupaten tempat acara akan diselenggarakan")
                        .font(AppFont.Raleway.footnoteLarge)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        withAnimation {
                            showCityDropdown.toggle()
                        }
                    }) {
                        HStack {
                            Text(selectedCity?.name ?? "Pilih Kota/Kabupaten")
                                .foregroundColor(selectedCity == nil ? .gray : .black)
                            Spacer()
                            Image(systemName: showCityDropdown ? "chevron.up" : "chevron.down")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("tertiary"), lineWidth: 2))
                    }
                    
                    if showCityDropdown && !addressViewModel.cityByProvince.isEmpty {
                        VStack {
                            ScrollView {
                                ForEach(addressViewModel.cityByProvince, id: \.id) { city in
                                    Button(action: {
                                        selectedCity = city
                                        showCityDropdown = false
                                    }) {
                                        Text(city.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .foregroundColor(.black)
                                    }
                                    Divider()
                                }
                            }
                            .frame(maxHeight: 200)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
            }
            
            
            CustomInputField(
                title: "Jumlah Peserta(Optional)",
                tip: "Contoh: 250",
                placeholder: "Estimasi jumlah peserta acara",
                text: $attendee,
                keyboardType: .numberPad
            )
            
            Button{
                withAnimation {
                    isStepTwo = true
                    if currentStep < 3 {
                        self.currentStep += 1
                    }
                }
            } label: {
                Text("Selanjutnya")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        if isFormComplete {
                            LinearGradient(
                                gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.gray.opacity(0.4)
                        }
                    }
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isFormComplete)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
}
