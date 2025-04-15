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
    @State private var showDetail = false
    @State private var isZooming = false
    
    init(artMapViewModel: ArtMapViewModel) {
        self.artMapViewModel = artMapViewModel
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if #available(iOS 17.0, *) {
                    Map(position: $cameraPosition) {
                        ForEach(artMapViewModel.artMap) { art in
                            Annotation("", coordinate: CLLocationCoordinate2D(latitude: art.latitude ?? 0.0, longitude: art.longitude ?? 0.0)) {
                                Image("custom-marker-red")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedArt = art
                                            showDetail = false
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                cameraPosition = .region(
                                                    MKCoordinateRegion(
                                                        center: CLLocationCoordinate2D(latitude: art.latitude ?? 0.0, longitude: art.longitude ?? 0.0),
                                                        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                                                    )
                                                )
                                            }	
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showDetail = true
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.7)
                    .cornerRadius(16)
                    .padding(.horizontal, 15)
                    .padding(.top)
                    .shadow(radius: 3)
                }

                Spacer()
            }
            .overlay(
                Group {
                    if let art = selectedArt, showDetail {
                        detailCard(for: art)
                            .transition(.move(edge: .bottom))
                    } else {
                        instructionCard
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: showDetail),
                alignment: .bottom
            )
            
            if artMapViewModel.isLoading {
                Loading(opacity: 1)
            }
        }
        .refreshable {
            artMapViewModel.fetchArtMap()
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func detailCard(for art: ArtMapResult) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(art.name ?? "")
                    .font(AppFont.Crimson.headerMedium)
                    .foregroundStyle(Color("primary"))
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDetail = false
                        selectedArt = nil
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            cameraPosition = .region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: -2.5489, longitude: 118.0149),
                                    span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
                                )
                            )
                        }
                    }
                }) {
                    Image(systemName: "x.circle")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.black)
                }

            }
            .padding(.bottom, 5)

            Text(art.subtitle ?? "")
                .font(AppFont.Raleway.bodyLarge)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)

            Spacer()

            HStack {
                Spacer()
                NavigationLink(destination: ArtMapDetail(artMapViewModel: artMapViewModel, name: art.name ?? "", slug: art.slug ?? "")) {
                    HStack {
                        Text("Lihat lebih lanjut")
                            .font(AppFont.Crimson.bodyLarge)
                            .foregroundStyle(Color("brick"))
                        Image(systemName: "arrow.right")
                            .font(AppFont.Crimson.bodyLarge)
                            .foregroundStyle(Color("brick"))
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 3)
        .padding(.horizontal, 15)
        .padding(.bottom, 40)
    }

    private var instructionCard: some View {
        Text("Klik pada setiap provinsi untuk mengetahui lebih lanjut tentang budaya dan seni yang dimilikinya.")
            .font(AppFont.Raleway.footnoteSmall)
            .foregroundStyle(Color("brick"))
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 3)
            .padding(.horizontal, 15)
            .padding(.bottom, 40)
    }


}
