//
//  Header.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct Header: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    init(profileViewModel: ProfileViewModel, homeViewModel: HomeViewModel) {
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                if let profilePicture = profileViewModel.profile?.profilePicture,
                   let url = URL(string: profilePicture) {
                    WebImage(url: url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                } else {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("primary").opacity(0.3), Color("tertiary").opacity(0.3)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("primary"))
                    }
                }
                
                Text("Halo, \(profileViewModel.profile?.name ?? "Guest")👋")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                NavigationLink(destination: CartView(viewModel: homeViewModel)) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.system(size: 18))
                            .foregroundColor(Color("primary"))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                        
                        if homeViewModel.totalCart > 0 {
                            Text("\(homeViewModel.totalCart)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(Color("brick"))
                                .clipShape(Circle())
                                .offset(x: 4, y: -4)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            SearchBar(text: $homeViewModel.searchText, isLoading: homeViewModel.isLoading)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
        .padding(.top, safeAreaInsets.top > 0 ? safeAreaInsets.top : 20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("tertiary"), Color("primary")]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 24))
            .shadow(color: Color("primary").opacity(0.2), radius: 8, y: 4)
            .ignoresSafeArea(edges: .top)
        )
    }
    
    private var safeAreaInsets: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets
        }
        return .zero
    }
}
