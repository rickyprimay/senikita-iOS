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
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    profileHeaderSection
                    
                    accountSection
                    
                    supportSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
            .refreshable {
                profileViewModel.getProfile()
            }
            
            if showLogoutAlert {
                LogoutAlert(isShowing: $showLogoutAlert) {
                    authViewModel.logout()
                }
            }
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            if let profilePicture = profileViewModel.profile?.profilePicture,
               let url = URL(string: profilePicture) {
                WebImage(url: url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 3)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            } else {
                ZStack {
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                }
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            }
            
            VStack(spacing: 4) {
                Text(profileViewModel.profile?.name ?? "Guest")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
                
                if let email = profileViewModel.profile?.email {
                    Text(email)
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
            }
            
            NavigationLink(destination: EditProfile(profileViewModel: profileViewModel)) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                    Text("Edit Profile")
                        .font(AppFont.Nunito.bodyMedium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color("brick"))
                .cornerRadius(25)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Akun")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                NavigationLink(destination: ChangePassword(profileViewModel: profileViewModel)) {
                    ProfileRow(icon: "key", title: "Ubah Password")
                }
                
                Divider().padding(.leading, 52)
                
                NavigationLink(destination: AddressDetail()) {
                    ProfileRow(icon: "mappin.and.ellipse", title: "Alamat")
                }
                
                Divider().padding(.leading, 52)
                
                NavigationLink(destination: History(isFromPayment: false)) {
                    ProfileRow(icon: "clock.arrow.circlepath", title: "Riwayat Transaksi")
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Lainnya")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                NavigationLink(destination: Help()) {
                    ProfileRow(icon: "questionmark.circle", title: "Bantuan")
                }
                
                Divider().padding(.leading, 52)
                
                Button {
                    showLogoutAlert = true
                } label: {
                    ProfileRow(icon: "rectangle.portrait.and.arrow.right", title: "Keluar", isDestructive: true)
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
    }
}
