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
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -2.5489, longitude: 118.0149),
            span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        )
    )
    
    @State private var selectedArt: ArtMapResult? = nil
    @State private var isFullScreen = false
    @State private var isZooming = false
    
    init(artMapViewModel: ArtMapViewModel) {
        self.artMapViewModel = artMapViewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    if !isFullScreen {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Peta Kesenian")
                                .font(AppFont.Crimson.headerMedium)
                                .foregroundStyle(.black)
                            
                            Text("Peta ini menunjukkan provinsi-provinsi di Indonesia dengan kesenian khas yang unik. Klik pada setiap provinsi untuk mengetahui lebih lanjut tentang budaya dan seni yang dimilikinya.")
                                .font(AppFont.Raleway.bodyMedium)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                        }
                        .padding(.vertical)
                    }
                    
                    ZStack(alignment: .topTrailing) {
                        if #available(iOS 17.0, *) {
                            Map(position: $cameraPosition) {
                                ForEach(artMapViewModel.artMap) { art in
                                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: art.latitude ?? 0.0, longitude: art.longitude ?? 0.0)) {
                                        
                                        if selectedArt?.id == art.id {
                                            VStack(alignment: .leading, spacing: 5) {
                                                HStack {
                                                    Text(art.name ?? "")
                                                        .font(AppFont.Crimson.bodyMedium)
                                                        .foregroundStyle(Color("primary"))
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation {
                                                            selectedArt = nil
                                                            isZooming = false
                                                            cameraPosition = .region(
                                                                MKCoordinateRegion(
                                                                    center: CLLocationCoordinate2D(latitude: -2.5489, longitude: 118.0149),
                                                                    span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
                                                                )
                                                            )
                                                        }
                                                    }) {
                                                        Image(systemName: "x.circle")
                                                            .font(AppFont.Raleway.bodyMedium)
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                                .padding(.bottom, 5)
                                                
                                                Text(art.subtitle ?? "")
                                                    .font(AppFont.Raleway.footnoteSmall)
                                                    .foregroundStyle(.black)
                                                    .multilineTextAlignment(.leading)
                                                
                                                HStack {
                                                    Spacer()
                                                    NavigationLink(destination: ArtMapDetail(artMapViewModel: artMapViewModel, name: art.name ?? "", slug: art.slug ?? "")) {
                                                        HStack {
                                                            Text("Lihat lebih lanjut")
                                                                .font(AppFont.Crimson.footnoteSmall)
                                                                .foregroundStyle(Color("brick"))
                                                            Image(systemName: "arrow.right")
                                                                .font(AppFont.Crimson.footnoteSmall)
                                                                .foregroundStyle(Color("brick"))
                                                        }
                                                    }
                                                }
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .frame(width: 300, height: 200)
                                        } else {
                                            Image("custom-marker-blue")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .onTapGesture {
                                                    withAnimation {
                                                        selectedArt = art
                                                        isZooming = true
                                                        cameraPosition = .region(
                                                            MKCoordinateRegion(
                                                                center: CLLocationCoordinate2D(latitude: art.latitude ?? 0.0, longitude: art.longitude ?? 0.0),
                                                                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                                                            )
                                                        )
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .frame(height: isFullScreen ? UIScreen.main.bounds.height : 400)
                            .edgesIgnoringSafeArea(isFullScreen ? .all : .top)
                            .cornerRadius(isFullScreen ? 0 : 10)
                            .padding(isFullScreen ? 0 : 10)
                        }
                        
                        Button(action: {
                            withAnimation {
                                isFullScreen.toggle()
                            }
                        }) {
                            Image(systemName: isFullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 20))
                                .padding(10)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                    }
                } 
            }
            
            if artMapViewModel.isLoading {
                Loading(opacity: 1)
            }
        }
        .refreshable {
            artMapViewModel.fetchArtMap()
        }
        .navigationBarHidden(true)
    }
}
