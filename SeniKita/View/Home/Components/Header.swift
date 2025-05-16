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
    @State var search: String = ""
    
    init(profileViewModel: ProfileViewModel, homeViewModel: HomeViewModel) {
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack {
            Color("tertiary")
                .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 10) {
                HStack(alignment: .center) {
                    
                    if let profilePicture = profileViewModel.profile?.profilePicture,
                       let url = URL(string: profilePicture) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Text("Halo, \(profileViewModel.profile?.name ?? "Guest")👋")
                        .font(AppFont.Raleway.bodyMedium)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    NavigationLink(destination: CartView(viewModel: homeViewModel)){
                        Image(systemName: "cart")
                            .font(AppFont.Crimson.bodyMedium)
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 15)
                .frame(height: 50, alignment: .center)
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(AppFont.Raleway.footnoteLarge)
                            .foregroundColor(.black)
                        
                        ZStack(alignment: .leading) {
                            if search.isEmpty {
                                Text("Cari Produk atau Service")
                                    .foregroundColor(.black.opacity(0.7))
                                    .font(AppFont.Raleway.footnoteLarge)
                                    .fontWeight(.regular)
                            }
                            
                            TextField("", text: $search)
                                .foregroundColor(.black)
                                .font(AppFont.Raleway.footnoteLarge)
                                .fontWeight(.regular)
                        }
                    }
                    .padding(10)
                    .background(Color.brown.opacity(0.3))
                    .cornerRadius(20)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(AppFont.Crimson.bodyMedium)
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 15)
        }
        .frame(height: 120)
    }
}
