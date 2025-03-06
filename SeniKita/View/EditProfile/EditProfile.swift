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
    @State var showImage: Bool = false
    @State var imagePicker = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var showErrorPopup: Bool = false
    @State private var showSuccessPopup: Bool = false
    
    @FocusState private var nameFocus: Bool
    @FocusState private var usernameFocus: Bool
    @FocusState private var callNumberFocus: Bool
    @FocusState private var birthDateFocus: Bool
    @FocusState private var birthLocationFocus: Bool
    @FocusState private var genderFocus: Bool
    
    private enum FocusField {
        case name, username, callNumber, birthLocation
    }
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("brick"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color("tertiary"))
    }
    
    private let genderOptions = ["Laki-laki", "Perempuan"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack {
                        if let profilePicture = profileViewModel.profile?.profilePicture,
                           let url = URL(string: profilePicture) {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .padding()
                        } else if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .padding()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                        Button("Pilih Foto Profil") {
                            showActionSheet.toggle()
                        }
                        .padding()
                        .font(AppFont.Crimson.bodyLarge)
                        .background(Color("brick"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .confirmationDialog("Pilih Sumber Gambar", isPresented: $showActionSheet) {
                            Button("Camera") {
                                source = .camera
                                imagePicker.toggle()
                            }
                            Button("Photo Library") {
                                source = .photoLibrary
                                imagePicker.toggle()
                            }
                            Button("Batal", role: .cancel) {}
                        }
                    }
                    
                    CustomTextField(
                        label: "Nama",
                        text: $name,
                        placeholder: "Masukkan nama",
                        isSecure: false,
                        fontType: .crimson,
                        nextFocus: $usernameFocus,
                        isLast: false
                    ).focused($nameFocus)
                    
                    CustomTextField(
                        label: "Username",
                        text: $username,
                        placeholder: "Masukkan username",
                        isSecure: false,
                        fontType: .crimson,
                        nextFocus: $callNumberFocus,
                        isLast: false
                    ).focused($usernameFocus)
                    
                    CustomTextField(
                        label: "Nomor Telepon",
                        text: $callNumber,
                        placeholder: "Masukkan nomor telepon",
                        isSecure: false,
                        keyboardType: .phonePad,
                        fontType: .crimson,
                        nextFocus: $birthDateFocus,
                        isLast: false
                    ).focused($callNumberFocus)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tanggal Lahir")
                            .font(.footnote)
                            .foregroundColor(.black)
                        
                        Button(action: {
                            withAnimation {
                                showDatePicker.toggle()
                            }
                        }) {
                            Text(dateFormatter.string(from: birthDate))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("brick"), lineWidth: 2))
                        }
                        
                        if showDatePicker {
                            VStack {
                                DatePicker("", selection: $birthDate, displayedComponents: .date)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("brick"), lineWidth: 2))
                                
                                Button("Submit") {
                                    withAnimation {
                                        showDatePicker = false
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("brick"))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                    }
                    
                    CustomTextField(
                        label: "Tempat Lahir",
                        text: $birthLocation,
                        placeholder: "Masukkan tempat lahir",
                        isSecure: false,
                        fontType: .crimson,
                        nextFocus: $genderFocus,
                        isLast: false
                    ).focused($birthLocationFocus)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Jenis Kelamin")
                            .font(AppFont.Crimson.footnoteLarge)
                            .foregroundColor(.black)
                        Picker("Pilih Jenis Kelamin", selection: $gender) {
                            ForEach(genderOptions, id: \ .self) { option in
                                Text(option).tag(option)
                                    .font(AppFont.Crimson.footnoteLarge)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Button(action: {
                        profileViewModel.updateProfile(
                            name: name,
                            username: username,
                            callNumber: callNumber,
                            birthDate: dateFormatter.string(from: birthDate),
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
                    }) {
                        Text(profileViewModel.isLoading ? "Loading..." : "Simpan")
                            .font(AppFont.Crimson.footnoteLarge)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color("brick"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(profileViewModel.isLoading)
                    
                    
                    Spacer()
                }
                .padding()
                .overlay(
                    Group {
                        if showErrorPopup, let errorMessage = profileViewModel.errorMessage {
                            BasePopup(isShowing: $showErrorPopup, message: errorMessage, onConfirm: {
                                showErrorPopup = false
                                presentationMode.wrappedValue.dismiss()
                                profileViewModel.errorMessage = nil
                            })
                            .transition(.opacity)
                        }
                        if showSuccessPopup {
                            BasePopup(isShowing: $showSuccessPopup, message: "Profil berhasil diperbarui!", onConfirm: {
                                showSuccessPopup = false
                                presentationMode.wrappedValue.dismiss()
                            }, isSuccess: true)
                            .transition(.opacity)
                        }
                    }
                )
                
            }
            .sheet(isPresented: $imagePicker) {
                ImagePicker(showPicker: $imagePicker, image: $imageData, source: source)
            }
            .onAppear {
                if let profile = profileViewModel.profile {
                    name = profile.name ?? ""
                    username = profile.username ?? ""
                    callNumber = profile.callNumber ?? ""
                    birthLocation = profile.birthLocation ?? ""
                    gender = (profile.gender == "male") ? "Laki-laki" : "Perempuan"

                    if let birthDateString = profile.birthDate,
                       let date = dateFormatter.date(from: birthDateString) {
                        birthDate = date
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
                            .font(.system(size: 18, weight: .bold))
                    }
                    .tint(Color("brick"))
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit Profile")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("brick"))
                }
            }
            
            if profileViewModel.isLoading {
                Loading(opacity: 0.5)
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
}
