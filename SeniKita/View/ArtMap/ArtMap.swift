//
//  ArtMap.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import SwiftUI
import MapKit

struct ArtMap: View {
    @ObservedObject var artMapViewModel: ArtMapViewModel
    @Environment(\.isShowingTabBar) var isShowingTabBar
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -2.5489, longitude: 118.0149),
            span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        )
    )
    
    @State private var selectedArt: ArtMapResult? = nil
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ZStack(alignment: .bottom) {
                    mapSection
                    
                    if let art = selectedArt, showDetail {
                        detailCard(for: art)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else if !showDetail {
                        instructionCard
                            .transition(.opacity)
                    }
                }
            }
            
            if artMapViewModel.isLoading {
                Loading(opacity: 0.6)
            }
        }
        .refreshable {
            artMapViewModel.fetchArtMap()
        }
        .navigationBarHidden(true)
        .onChange(of: showDetail) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingTabBar.wrappedValue = !newValue
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showDetail)
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Peta Kesenian")
                        .font(AppFont.Nunito.headerMedium)
                        .foregroundColor(.primary)
                    
                    Text("Jelajahi kesenian Indonesia")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color("primary").opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "map.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color("primary"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }
    
    private var mapSection: some View {
        Group {
            if #available(iOS 17.0, *) {
                Map(position: $cameraPosition) {
                    ForEach(artMapViewModel.artMap) { art in
                        Annotation("", coordinate: CLLocationCoordinate2D(
                            latitude: art.latitude ?? 0.0,
                            longitude: art.longitude ?? 0.0
                        )) {
                            MapMarkerView(
                                isSelected: selectedArt?.id == art.id,
                                onTap: {
                                    selectArt(art)
                                }
                            )
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
            }
        }
    }
    
    private func selectArt(_ art: ArtMapResult) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedArt = art
            showDetail = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.5)) {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: art.latitude ?? 0.0,
                            longitude: art.longitude ?? 0.0
                        ),
                        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                    )
                )
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showDetail = true
            }
        }
    }
    
    private func resetMap() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showDetail = false
            selectedArt = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: -2.5489, longitude: 118.0149),
                        span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
                    )
                )
            }
        }
    }
    
    @ViewBuilder
    private func detailCard(for art: ArtMapResult) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(UIColor.systemGray4))
                .frame(width: 40, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(art.name ?? "")
                            .font(AppFont.Nunito.subtitle)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12))
                            Text("Provinsi")
                                .font(AppFont.Raleway.footnoteSmall)
                        }
                        .foregroundColor(Color("primary"))
                    }
                    
                    Spacer()
                    
                    Button(action: resetMap) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(width: 28, height: 28)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(14)
                    }
                }
                
                Text(art.subtitle ?? "")
                    .font(AppFont.Raleway.bodyMedium)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                NavigationLink(destination: ArtMapDetail(
                    artMapViewModel: artMapViewModel,
                    name: art.name ?? "",
                    slug: art.slug ?? ""
                )) {
                    HStack {
                        Text("Jelajahi Kesenian")
                            .font(AppFont.Nunito.bodyMedium)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color("primary"))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 40)
        .background(
            Color.white
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .ignoresSafeArea(.container, edges: .bottom)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
    }
    
    private var instructionCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color("primary").opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color("primary"))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Ketuk marker untuk melihat detail")
                    .font(AppFont.Nunito.footnoteSmall)
                    .foregroundColor(.primary)
                
                Text("Jelajahi kesenian dari berbagai provinsi")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
        .padding(.horizontal, 16)
        .padding(.bottom, 100)
    }
}

struct MapMarkerView: View {
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color("primary") : Color.white)
                    .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                
                Image(systemName: "theatermasks.fill")
                    .font(.system(size: isSelected ? 20 : 16))
                    .foregroundColor(isSelected ? .white : Color("primary"))
            }
            
            if isSelected {
                Triangle()
                    .fill(Color("primary"))
                    .frame(width: 12, height: 8)
                    .offset(y: -2)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .onTapGesture(perform: onTap)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
