//
//  EditProfile.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 04/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfile: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var callNumber: String = ""
    @State private var birthDate: Date = Date()
    @State private var birthLocation: String = ""
    @State private var gender: String = ""
    @State private var showDatePicker: Bool = false
    
    @State var imageData: Data = .init(capacity: 0)
    @State var imagePicker = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var showErrorPopup: Bool = false
    @State private var showSuccessPopup: Bool = false
    
    private let genderOptions = ["Laki-laki", "Perempuan"]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    profilePhotoSection
                    personalInfoSection
                    birthInfoSection
                    genderSection
                    
                    saveButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            
            if profileViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            if showErrorPopup, let errorMessage = profileViewModel.errorMessage {
                BasePopup(isShowing: $showErrorPopup, message: errorMessage, onConfirm: {
                    showErrorPopup = false
                    profileViewModel.errorMessage = nil
                })
            }
            
            if showSuccessPopup {
                BasePopup(isShowing: $showSuccessPopup, message: "Profil berhasil diperbarui!", onConfirm: {
                    showSuccessPopup = false
                    presentationMode.wrappedValue.dismiss()
                }, isSuccess: true)
            }
        }
        .sheet(isPresented: $imagePicker) {
            ImagePicker(showPicker: $imagePicker, image: $imageData, source: source)
        }
        .onAppear(perform: loadProfileData)
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
                Text("Edit Profil")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
            }
        }
        .hideTabBar()
    }
    
    private var profilePhotoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else if let profilePicture = profileViewModel.profile?.profilePicture,
                          let url = URL(string: profilePicture) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                }
                
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 100, height: 100)
            }
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            
            Button {
                showActionSheet.toggle()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 12))
                    Text("Ubah Foto")
                        .font(AppFont.Nunito.footnoteSmall)
                }
                .foregroundColor(Color("primary"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("primary").opacity(0.1))
                .cornerRadius(20)
            }
            .confirmationDialog("Pilih Sumber Gambar", isPresented: $showActionSheet) {
                Button("Kamera") {
                    source = .camera
                    imagePicker.toggle()
                }
                Button("Galeri Foto") {
                    source = .photoLibrary
                    imagePicker.toggle()
                }
                Button("Batal", role: .cancel) {}
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Informasi Pribadi")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                EditProfileField(
                    label: "Nama Lengkap",
                    text: $name,
                    placeholder: "Masukkan nama lengkap"
                )
                
                Divider().padding(.leading, 16)
                
                EditProfileField(
                    label: "Username",
                    text: $username,
                    placeholder: "Masukkan username"
                )
                
                Divider().padding(.leading, 16)
                
                EditProfileField(
                    label: "Nomor Telepon",
                    text: $callNumber,
                    placeholder: "08xxxxxxxxxx",
                    keyboardType: .phonePad
                )
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
    }
    
    private var birthInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data Kelahiran")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tanggal Lahir")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(Color("primary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                Divider().padding(.leading, 16)
                
                EditProfileField(
                    label: "Tempat Lahir",
                    text: $birthLocation,
                    placeholder: "Masukkan tempat lahir"
                )
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
    }
    
    private var genderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Jenis Kelamin")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            HStack(spacing: 12) {
                ForEach(genderOptions, id: \.self) { option in
                    Button {
                        gender = option
                    } label: {
                        Text(option)
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(gender == option ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(gender == option ? Color("primary") : Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                    }
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveProfile) {
            Text(profileViewModel.isLoading ? "Menyimpan..." : "Simpan Perubahan")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("primary"))
                .cornerRadius(12)
        }
        .disabled(profileViewModel.isLoading)
    }
    
    private func loadProfileData() {
        if let profile = profileViewModel.profile {
            name = profile.name ?? ""
            username = profile.username ?? ""
            callNumber = profile.callNumber ?? ""
            birthLocation = profile.birthLocation ?? ""
            
            if let genderValue = profile.gender {
                gender = (genderValue == "male" || genderValue == "Laki-laki") ? "Laki-laki" : "Perempuan"
            }
            
            if let dateString = profile.birthDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                if let date = formatter.date(from: dateString) {
                    birthDate = date
                }
            }
        }
    }
    
    private func saveProfile() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let finalDateString = formatter.string(from: birthDate)
        
        profileViewModel.updateProfile(
            name: name,
            username: username,
            callNumber: callNumber,
            birthDateString: finalDateString,
            birthLocation: birthLocation,
            gender: gender,
            profilePicture: imageData.isEmpty ? nil : imageData
        ) { success, message in
            if success {
                showSuccessPopup = true
            } else {
                showErrorPopup = true
            }
        }
    }
}

struct EditProfileField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .font(AppFont.Raleway.bodyMedium)
                .keyboardType(keyboardType)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
