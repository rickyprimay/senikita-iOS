//
//  Profile.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct Profile: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var showLogoutAlert = false
    
    init(authViewModel: AuthViewModel, profileViewModel: ProfileViewModel) {
        self.authViewModel = authViewModel
        self.profileViewModel = profileViewModel
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack {
                    if let profilePicture = profileViewModel.profile?.profilePicture,
                       let url = URL(string: profilePicture) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            )
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .padding()
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            )
                    }
                    
                    Text(profileViewModel.profile?.name ?? "Guest")
                        .font(AppFont.Crimson.bodyMedium)
                        .fontWeight(.regular)
                    
                    NavigationLink(destination: EditProfile(profileViewModel: profileViewModel)) {
                        Text("Edit Profile")
                            .font(AppFont.Crimson.bodyMedium)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("tertiary"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 30)
                }
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        NavigationLink(destination: ChangePassword(profileViewModel: profileViewModel)){
                            ProfileRow(icon: "person.badge.key", title: "Ubah Password", color: .black)
                        }
                        ProfileRow(icon: "gearshape", title: "Pengaturan", color: .black)
                        ProfileRow(icon: "cart", title: "Pembelian Anda", color: .black)
                        NavigationLink(destination: AddressDetail()) {
                            ProfileRow(icon: "mappin.and.ellipse", title: "Alamat", color: .black)
                        }
                        NavigationLink(destination: History(isFromPayment: false)) {
                            ProfileRow(icon: "newspaper", title: "Daftar Transaksi", color: .black)
                        }
                    }
                    
                    Divider()
                    
                    VStack {
                        NavigationLink(destination: Help()) {
                            ProfileRow(icon: "questionmark.circle", title: "Support & Bantuan", color: .black)
                        }
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            ProfileRow(icon: "arrow.backward.circle", title: "Log out", color: Color("customRed"))
                        }
                    }
                    
                    Spacer()
                }
                .refreshable {
                    profileViewModel.getProfile()
                }
            }
            .padding(.top, 30)
            .padding()
            
            if showLogoutAlert {
                LogoutAlert(isShowing: $showLogoutAlert) {
                    authViewModel.logout()
                }
            }
            
        }
    }
}
