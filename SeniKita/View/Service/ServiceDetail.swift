//
//  ServiceDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ServiceDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var serviceViewModel = ServiceViewModel()
    @ObservedObject var homeViewModel: HomeViewModel
    
    @State private var showShareSheet = false
    
    var idService: Int
    
    init(idService: Int, homeViewModel: HomeViewModel) {
        self.idService = idService
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack() {
                    
                    ZStack(alignment: .topTrailing) {
                        WebImage(url: URL(string: serviceViewModel.service?.thumbnail ?? ""))
                            .resizable()
                            .indicator(.activity)
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack{
                            
                            Text("Rp\(serviceViewModel.service?.price ?? 0)")
                                .font(AppFont.Raleway.titleMedium)
                                .foregroundColor(Color("primary"))
                                .lineLimit(1)
                            
                            Text("per \(serviceViewModel.service?.type ?? "")")
                                .font(AppFont.Raleway.footnoteSmall)
                                .foregroundColor(.black)
                            
                        }
                        
                        Text(serviceViewModel.service?.name ?? "")
                            .font(AppFont.Raleway.titleMedium)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        HStack(spacing: 4) {
                            Text("Sudah menerima \(serviceViewModel.service?.sold ?? "0") pesanan")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            
                            Text("•")
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            
                            Text(String(format: "%.1f", serviceViewModel.service?.average_rating ?? 0.0))
                                .font(AppFont.Raleway.bodyMedium)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                            
                            Text("(\(serviceViewModel.service?.rating_count ?? 0) Rating)")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                        }
                        
                        Text("Jumlah orang: \(serviceViewModel.service?.person_amount ?? "0")")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        HStack {
                            Text("Kategori:")
                            Text(serviceViewModel.service?.category?.name ?? "")
                                .foregroundStyle(Color("primary"))
                                .fontWeight(.regular)
                        }
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        
                        Text(serviceViewModel.service?.desc?.stripHTML ?? "")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        
                        Text("Alamat Layanan Kesenian")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.black)
                            .bold()
                        
                        HStack {
                            
                            Image(systemName: "mappin.and.ellipse")
                                .font(AppFont.Raleway.bodyMedium)
                            
                            Text("Jasa dari")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                            
                            Text(serviceViewModel.service?.shop?.region ?? "")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                                .bold()
                            
                        }
                        
                        HStack{
                            Image(systemName: "dollarsign.circle.fill")
                                .font(AppFont.Raleway.bodyMedium)
                            
                            Text("Pembayaran per")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                            
                            Text(serviceViewModel.service?.type ?? "")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Profil Seniman")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                                .bold()
                            
                            HStack(alignment: .center, spacing: 12) {
                                if let profilePicture = serviceViewModel.service?.shop?.profile_picture, !profilePicture.isEmpty {
                                    WebImage(url: URL(string: profilePicture))
                                        .resizable()
                                        .indicator(.activity)
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(serviceViewModel.service?.shop?.name ?? "")
                                        .font(AppFont.Raleway.bodyMedium)
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    Text(serviceViewModel.service?.shop?.region ?? "")
                                        .font(AppFont.Raleway.bodyMedium)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Text(serviceViewModel.service?.shop?.desc ?? "")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: false, vertical: false)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.top)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Jasa Kesenian Lainnya")
                                    .font(AppFont.Raleway.titleMedium)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.vertical)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(homeViewModel.services) { service in
                                        NavigationLink(
                                            destination: ServiceDetail(idService: service.id, homeViewModel: homeViewModel),
                                            label: {
                                                CardService(service: service)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 15)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
            }
            .onAppear{
                serviceViewModel.fetchServiceById(idService: idService, isLoad: true)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(AppFont.Crimson.bodyLarge)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .tint(Color("tertiary"))
                }
                ToolbarItem(placement: .principal) {
                    Text("Detail Jasa")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("tertiary"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showShareSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(AppFont.Crimson.bodyLarge)
                            .frame(width: 40, height: 40)
                            .background(Color.brown.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .tint(Color("tertiary"))
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [serviceViewModel.service?.thumbnail ?? "Service ini menarik!"])
            }
            if serviceViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        if let service = serviceViewModel.service {
                            NavigationLink(destination: PaymentService(
                                imageService: service.thumbnail ?? "",
                                serviceId: service.id,
                                nameShop: service.shop?.name ?? "",
                                nameService: service.name ?? "",
                                price: service.price?.toDouble() ?? 0
                            )) {
                                Text("Pesan Sekarang")
                                    .font(AppFont.Nunito.bodyMedium)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color("primary"))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding(.bottom, 25)
                .background(Color.clear)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
}
