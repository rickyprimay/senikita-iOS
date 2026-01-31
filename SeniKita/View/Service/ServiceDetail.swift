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
        ZStack(alignment: .bottom) {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                
                if serviceViewModel.isLoading {
                    serviceDetailSkeleton
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            serviceImageCard
                            serviceInfoCard
                            locationCard
                            sellerCard
                            otherServicesSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 120)
                    }
                }
            }
            
            if !serviceViewModel.isLoading {
                actionBar
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            serviceViewModel.fetchServiceById(idService: idService, isLoad: true)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [serviceViewModel.service?.thumbnail ?? "Service ini menarik!"])
        }
        .hideTabBar()
    }
    
    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("primary"))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            }
            
            Spacer()
            
            Text("Detail Jasa")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                showShareSheet.toggle()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 14))
                    .foregroundColor(Color("primary"))
                    .frame(width: 36, height: 36)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Service Image
    private var serviceImageCard: some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: serviceViewModel.service?.thumbnail ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: geometry.size.width, height: 240)
                .clipped()
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
    
    // MARK: - Service Info Card
    private var serviceInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Price with type
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Rp\(formatPrice(serviceViewModel.service?.price ?? 0))")
                    .font(AppFont.Nunito.headerLarge)
                    .foregroundColor(Color("primary"))
                
                Text("per \(serviceViewModel.service?.type ?? "")")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(6)
            }
            
            // Name
            Text(serviceViewModel.service?.name ?? "")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            // Stats row
            HStack(spacing: 12) {
                Text("Sudah menerima \(serviceViewModel.service?.sold ?? "0") pesanan")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", serviceViewModel.service?.average_rating ?? 0))
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                    
                    Text("(\(serviceViewModel.service?.rating_count ?? 0))")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Person amount & Category
            HStack(spacing: 16) {
                Label {
                    Text("\(serviceViewModel.service?.person_amount ?? "0") orang")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(Color("primary"))
                }
                
                Spacer()
                
                Text(serviceViewModel.service?.category?.name ?? "")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color("tertiary"))
                    .cornerRadius(8)
            }
            
            Divider()
            
            // Description
            Text(serviceViewModel.service?.desc?.stripHTML ?? "")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Location Card
    private var locationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Alamat Layanan")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("primary"))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Jasa dari")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    Text(serviceViewModel.service?.shop?.region ?? "")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("tertiary"))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pembayaran per")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    Text(serviceViewModel.service?.type ?? "")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Seller Card
    private var sellerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Profil Seniman")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                if let profilePicture = serviceViewModel.service?.shop?.profile_picture,
                   !profilePicture.isEmpty {
                    WebImage(url: URL(string: profilePicture))
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("primary").opacity(0.2), lineWidth: 2)
                        )
                } else {
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 56, height: 56)
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(serviceViewModel.service?.shop?.name ?? "")
                        .font(AppFont.Nunito.bodyLarge)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color("primary"))
                        Text(serviceViewModel.service?.shop?.region ?? "")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            Text(serviceViewModel.service?.shop?.desc ?? "Deskripsi toko belum tersedia.")
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Other Services
    private var otherServicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Jasa Kesenian Lainnya")
                .font(AppFont.Nunito.headerMedium)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(homeViewModel.services.filter { $0.id != idService }.prefix(10)) { service in
                        NavigationLink(
                            destination: ServiceDetail(idService: service.id, homeViewModel: homeViewModel),
                            label: {
                                CardService(service: service)
                            }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Action Bar
    private var actionBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            if let service = serviceViewModel.service {
                NavigationLink(destination: PaymentService(
                    imageService: service.thumbnail ?? "",
                    serviceId: service.id,
                    nameShop: service.shop?.name ?? "",
                    nameService: service.name ?? "",
                    price: service.price?.toDouble() ?? 0
                )) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 16))
                        Text("Pesan Sekarang")
                            .font(AppFont.Nunito.bodyLarge)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color("primary").opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 30)
                .background(Color.white)
            }
        }
    }
    
    // MARK: - Skeleton
    private var serviceDetailSkeleton: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Image skeleton
                SkeletonLoading(width: .infinity, height: 240, cornerRadius: 20)
                
                // Info card skeleton
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        SkeletonLoading(width: 120, height: 28)
                        SkeletonLoading(width: 60, height: 20, cornerRadius: 6)
                    }
                    SkeletonLoading(width: 200, height: 20)
                    SkeletonLoading(width: 180, height: 14)
                    Divider()
                    HStack {
                        SkeletonLoading(width: 90, height: 16)
                        Spacer()
                        SkeletonLoading(width: 80, height: 24, cornerRadius: 8)
                    }
                    Divider()
                    SkeletonLoading(width: .infinity, height: 60)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                
                // Location skeleton
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonLoading(width: 120, height: 18)
                    HStack(spacing: 12) {
                        SkeletonLoading(width: 20, height: 20, isCircle: true)
                        VStack(alignment: .leading, spacing: 4) {
                            SkeletonLoading(width: 60, height: 12)
                            SkeletonLoading(width: 120, height: 16)
                        }
                    }
                    Divider()
                    HStack(spacing: 12) {
                        SkeletonLoading(width: 20, height: 20, isCircle: true)
                        VStack(alignment: .leading, spacing: 4) {
                            SkeletonLoading(width: 100, height: 12)
                            SkeletonLoading(width: 60, height: 16)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                
                // Seller skeleton
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonLoading(width: 120, height: 18)
                    HStack(spacing: 12) {
                        SkeletonLoading(width: 56, height: 56, isCircle: true)
                        VStack(alignment: .leading, spacing: 6) {
                            SkeletonLoading(width: 140, height: 18)
                            SkeletonLoading(width: 100, height: 14)
                        }
                    }
                    SkeletonLoading(width: .infinity, height: 40)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: - Helper
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
