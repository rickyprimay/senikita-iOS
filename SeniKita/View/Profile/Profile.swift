//
//  Profile.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct Profile: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .padding()
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        )
                    
                    Text(profileViewModel.profile?.name ?? "Guest")
                        .font(AppFont.Crimson.bodyMedium)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        
                    }) {
                        Text("Edit Profile")
                            .font(AppFont.Crimson.bodyMedium)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("brick"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 30)
                }
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        NavigationLink(destination: ChangePassword()){
                            ProfileRow(icon: "person.badge.key", title: "Ubah Password", color: Color("brick"))
                        }
                        ProfileRow(icon: "gearshape", title: "Pengaturan", color: Color("brick"))
                        ProfileRow(icon: "cart", title: "Pembelian Anda", color: Color("brick"))
                        ProfileRow(icon: "mappin.and.ellipse", title: "Alamat", color: Color("brick"))
                        ProfileRow(icon: "newspaper", title: "Riwayat Pembelian", color: Color("brick"))
                    }
                    
                    Divider()
                    
                    VStack {
                        Button(action: {}) {
                            ProfileRow(icon: "questionmark.circle", title: "Support & Bantuan", color: Color("brick"))
                        }
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            ProfileRow(icon: "arrow.backward.circle", title: "Log out", color: Color("customRed"))
                        }
                    }
                    
                    Spacer()
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
//        .animation(.easeInOut, value: showLogoutAlert)
    }
}
