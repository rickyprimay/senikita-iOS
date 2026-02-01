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
    @Binding var provinceId: Int
    @Binding var cityId: Int
    
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var showProvinceDropdown = false
    @State private var showCityDropdown = false

    @State private var selectedProvince: Province?
    @State private var selectedCity: City?

    @ObservedObject var addressViewModel: AddressViewModel
    @ObservedObject var paymentServiceViewModel: PaymentServiceViewModel

    @Binding var eventLocation: String
    @Binding var attendee: String
    @Binding var isStepTwo: Bool

    var isFormComplete: Bool {
        return !namePIC.isEmpty && !callNumber.isEmpty && !eventName.isEmpty && !eventLocation.isEmpty && selectedProvince != nil && selectedCity != nil
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Service Card
            serviceCard
            
            // MARK: - Form Fields
            VStack(spacing: 16) {
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
                
                // Date Picker
                datePickerField
                    .zIndex(4)
                
                // Time Picker
                timePickerField
                    .zIndex(3)
                
                CustomTextAreaField(
                    title: "Lokasi Acara",
                    tip: "Masukkan alamat lengkap acara, termasuk nama jalan, nomor, kelurahan, dan kecamatan.",
                    placeholder: "Masukkan alamat lengkap acara",
                    text: $eventLocation
                )
                
                // Province Picker
                provincePickerField
                    .zIndex(2)
                
                // City Picker
                if selectedProvince != nil {
                    cityPickerField
                        .zIndex(1)
                }
                
                CustomInputField(
                    title: "Jumlah Peserta (Opsional)",
                    tip: "Contoh: 250",
                    placeholder: "Estimasi jumlah peserta acara",
                    text: $attendee,
                    keyboardType: .numberPad
                )
            }
            
            // MARK: - Next Button
            nextButton
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismissAllDropdowns()
        }
    }
    
    // MARK: - Service Card
    private var serviceCard: some View {
        HStack(spacing: 16) {
            if let imageUrl = URL(string: imageService ?? "") {
                WebImage(url: imageUrl)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nameShop ?? "")
                    .font(AppFont.Raleway.footnoteLarge)
                    .foregroundColor(Color("tertiary"))
                
                Text(nameService ?? "")
                    .font(AppFont.Nunito.bodyLarge)
                    .bold()
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(price?.formatPrice() ?? "Rp0")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Date Picker Field
    private var datePickerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tanggal Acara")
                .font(AppFont.Nunito.bodyLarge)
                .bold()
            
            Text("Pilih tanggal yang sesuai dengan hari penyelenggaraan acara Anda.")
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showDatePicker.toggle()
                    showTimePicker = false
                    showProvinceDropdown = false
                    showCityDropdown = false
                }
            }) {
                HStack {
                    Text(dateFormatter.string(from: eventDate))
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(Color("tertiary"))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("tertiary"), lineWidth: 1.5)
                )
            }
            
            if showDatePicker {
                VStack(spacing: 12) {
                    DatePicker("", selection: $eventDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                    
                    Button {
                        withAnimation { showDatePicker = false }
                    } label: {
                        Text("Selesai")
                            .font(AppFont.Nunito.bodyMedium)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.15)))
            }
        }
    }
    
    // MARK: - Time Picker Field
    private var timePickerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Waktu Acara")
                .font(AppFont.Nunito.bodyLarge)
                .bold()
            
            Text("Masukkan waktu dimulainya acara dengan format 24 jam.")
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showTimePicker.toggle()
                    showDatePicker = false
                    showProvinceDropdown = false
                    showCityDropdown = false
                }
            }) {
                HStack {
                    Text(timeFormatter.string(from: eventTime))
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(Color("tertiary"))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("tertiary"), lineWidth: 1.5)
                )
            }
            
            if showTimePicker {
                VStack(spacing: 12) {
                    DatePicker("", selection: $eventTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                    
                    Button {
                        withAnimation { showTimePicker = false }
                    } label: {
                        Text("Selesai")
                            .font(AppFont.Nunito.bodyMedium)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.15)))
            }
        }
    }
    
    // MARK: - Province Picker Field
    private var provincePickerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Provinsi")
                .font(AppFont.Nunito.bodyLarge)
                .bold()
            
            Text("Pilih provinsi tempat acara akan diselenggarakan")
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showProvinceDropdown.toggle()
                    showDatePicker = false
                    showTimePicker = false
                    showCityDropdown = false
                    if showProvinceDropdown {
                        addressViewModel.getProvinces()
                    }
                }
            }) {
                HStack {
                    Text(selectedProvince?.name ?? "Pilih Provinsi")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(selectedProvince == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: showProvinceDropdown ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("tertiary"))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("tertiary"), lineWidth: 1.5)
                )
            }
            
            if showProvinceDropdown {
                VStack(spacing: 0) {
                    if addressViewModel.isLoadingProvinces {
                        // Skeleton Loading
                        VStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { _ in
                                HStack {
                                    SkeletonLoading(width: 150, height: 16, cornerRadius: 4)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                
                                Divider()
                                    .padding(.horizontal, 16)
                            }
                        }
                    } else if !addressViewModel.province.isEmpty {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                ForEach(addressViewModel.province, id: \.id) { province in
                                    Button {
                                        selectedProvince = province
                                        provinceId = province.id
                                        selectedCity = nil
                                        cityId = 0
                                        showProvinceDropdown = false
                                        addressViewModel.getCitiesByIdProvinces(idProvinces: province.id) { }
                                    } label: {
                                        HStack {
                                            Text(province.name)
                                                .font(AppFont.Nunito.bodyMedium)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                    }
                                    
                                    if province.id != addressViewModel.province.last?.id {
                                        Divider()
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: 220)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.15)))
            }
        }
    }
    
    // MARK: - City Picker Field
    private var cityPickerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kota/Kabupaten")
                .font(AppFont.Nunito.bodyLarge)
                .bold()
            
            Text("Pilih kota/kabupaten tempat acara akan diselenggarakan")
                .font(AppFont.Raleway.footnoteLarge)
                .foregroundColor(.secondary)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showCityDropdown.toggle()
                    showDatePicker = false
                    showTimePicker = false
                    showProvinceDropdown = false
                }
            }) {
                HStack {
                    Text(selectedCity?.name ?? "Pilih Kota/Kabupaten")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(selectedCity == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: showCityDropdown ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("tertiary"))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("tertiary"), lineWidth: 1.5)
                )
            }
            
            if showCityDropdown {
                VStack(spacing: 0) {
                    if addressViewModel.isLoadingCities {
                        // Skeleton Loading
                        VStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { _ in
                                HStack {
                                    SkeletonLoading(width: 150, height: 16, cornerRadius: 4)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                
                                Divider()
                                    .padding(.horizontal, 16)
                            }
                        }
                    } else if !addressViewModel.cityByProvince.isEmpty {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                ForEach(addressViewModel.cityByProvince, id: \.id) { city in
                                    Button {
                                        selectedCity = city
                                        cityId = city.id
                                        showCityDropdown = false
                                    } label: {
                                        HStack {
                                            Text(city.name)
                                                .font(AppFont.Nunito.bodyMedium)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                    }
                                    
                                    if city.id != addressViewModel.cityByProvince.last?.id {
                                        Divider()
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                    } else {
                        // Empty state
                        Text("Tidak ada kota/kabupaten")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .frame(maxHeight: 220)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.15)))
            }
        }
    }
    
    // MARK: - Next Button
    private var nextButton: some View {
        Button {
            withAnimation {
                isStepTwo = true
                if currentStep < 3 {
                    self.currentStep += 1
                }
            }
        } label: {
            Text("Selanjutnya")
                .font(AppFont.Nunito.bodyLarge)
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    isFormComplete ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.4)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: isFormComplete ? Color("primary").opacity(0.3) : .clear, radius: 8, y: 4)
        }
        .disabled(!isFormComplete)
        .padding(.top, 8)
    }
    
    // MARK: - Helper Functions
    private func dismissAllDropdowns() {
        showDatePicker = false
        showTimePicker = false
        showProvinceDropdown = false
        showCityDropdown = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
