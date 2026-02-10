//
//  MapLocationPicker.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 08/02/26.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - CLLocationCoordinate2D Extension

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

/// Interactive map component with draggable pin for location selection
struct MapLocationPicker: View {
    
    // MARK: - Bindings
    
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var addressString: String
    @Binding var province: String
    @Binding var city: String
    @Binding var postalCode: String
    @Binding var isGeocoding: Bool
    
    // MARK: - Validation Parameters
    
    var selectedProvinceName: String?
    var selectedCityName: String?
    
    // MARK: - State
    
    @StateObject private var locationManager = LocationManager()
    @State private var region: MKCoordinateRegion
    @State private var isDragging = false
    @State private var geocodingWorkItem: DispatchWorkItem?
    @State private var showLocationMismatchWarning = false
    
    // MARK: - Constants
    
    // Indonesia Bounding Box
    private let indonesiaBounds = (
        minLat: -11.0,  // Southern tip
        maxLat: 6.0,    // Northern tip
        minLon: 95.0,   // Western tip
        maxLon: 141.0   // Eastern tip (Papua)
    )
    
    private let defaultCoordinate = CLLocationCoordinate2D(
        latitude: -6.2088,  // Jakarta
        longitude: 106.8456
    )
    
    // MARK: - Initialization
    
    init(
        coordinate: Binding<CLLocationCoordinate2D?>,
        addressString: Binding<String>,
        province: Binding<String>,
        city: Binding<String>,
        postalCode: Binding<String>,
        isGeocoding: Binding<Bool>,
        selectedProvinceName: String? = nil,
        selectedCityName: String? = nil
    ) {
        self._coordinate = coordinate
        self._addressString = addressString
        self._province = province
        self._city = city
        self._postalCode = postalCode
        self._isGeocoding = isGeocoding
        self.selectedProvinceName = selectedProvinceName
        self.selectedCityName = selectedCityName
        
        // Initialize region with default or provided coordinate
        let initialCoordinate = coordinate.wrappedValue ?? CLLocationCoordinate2D(
            latitude: -6.2088,
            longitude: 106.8456
        )
        
        self._region = State(initialValue: MKCoordinateRegion(
            center: initialCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Map View
            MapView(
                region: $region,
                isDragging: $isDragging,
                onRegionChange: handleRegionChange
            )
            .ignoresSafeArea(edges: .top)
            
            // Center Pin
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(Color("brick"))
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                .offset(y: -25)
            
            // Use My Location Button
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: useMyLocation) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color("brick"))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                Spacer()
            }
            
            if isGeocoding {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        
                        Text("Mendapatkan alamat...")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(25)
                    .padding(.bottom, 20)
                }
            }
            
            if let errorMessage = locationManager.errorMessage {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                        
                        Text(errorMessage)
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Spacer()
                }
            }
            
            // Location Mismatch Warning
            if showLocationMismatchWarning {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                        
                        Text("Lokasi pin tidak sesuai dengan provinsi/kota yang dipilih")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.orange.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            setupInitialLocation()
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let location = newLocation {
                withAnimation {
                    region.center = location
                }
                coordinate = location
                performGeocodingDebounced(for: location)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInitialLocation() {
        // Request permission if not determined
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestLocationPermission()
        }
        
        // Use current location if available, otherwise use default or provided coordinate
        if let currentLocation = locationManager.currentLocation {
            region.center = currentLocation
            coordinate = currentLocation
            performGeocodingDebounced(for: currentLocation)
        } else if let providedCoordinate = coordinate {
            region.center = providedCoordinate
            performGeocodingDebounced(for: providedCoordinate)
        } else if locationManager.hasLocationPermission {
            locationManager.getCurrentLocation()
        } else {
            // Use default Jakarta coordinate
            coordinate = defaultCoordinate
            performGeocodingDebounced(for: defaultCoordinate)
        }
    }
    
    private func useMyLocation() {
        if !locationManager.hasLocationPermission {
            locationManager.requestLocationPermission()
        } else {
            locationManager.getCurrentLocation()
        }
    }
    
    private func handleRegionChange(_ newRegion: MKCoordinateRegion) {
        var clampedRegion = newRegion
        
        // Clamp coordinates to Indonesia bounding box
        clampedRegion.center.latitude = max(indonesiaBounds.minLat, min(indonesiaBounds.maxLat, newRegion.center.latitude))
        clampedRegion.center.longitude = max(indonesiaBounds.minLon, min(indonesiaBounds.maxLon, newRegion.center.longitude))
        
        region = clampedRegion
        coordinate = clampedRegion.center
        
        // Always trigger debounced geocoding (debounce handles the delay)
        performGeocodingDebounced(for: clampedRegion.center)
    }
    
    private func performGeocodingDebounced(for coordinate: CLLocationCoordinate2D) {
        // Cancel previous work item
        geocodingWorkItem?.cancel()
        
        // Create new work item with 1.5 second delay to prevent spam
        let workItem = DispatchWorkItem { [coordinate] in
            Task { @MainActor in
                await performGeocoding(for: coordinate)
            }
        }
        
        geocodingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
    }
    
    private func performGeocoding(for coordinate: CLLocationCoordinate2D) async {
        isGeocoding = true
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else {
                isGeocoding = false
                return
            }
            
            // Extract address components
            let street = placemark.thoroughfare ?? ""
            let subLocality = placemark.subLocality ?? ""
            let locality = placemark.locality ?? ""
            
            // Build address string
            var addressComponents: [String] = []
            if !street.isEmpty {
                addressComponents.append(street)
            }
            if !subLocality.isEmpty {
                addressComponents.append(subLocality)
            }
            if !locality.isEmpty && locality != subLocality {
                addressComponents.append(locality)
            }
            
            addressString = addressComponents.joined(separator: ", ")
            
            // Extract province (administrativeArea)
            province = placemark.administrativeArea ?? ""
            
            // Extract city (locality or subAdministrativeArea)
            city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
            
            // Extract postal code
            postalCode = placemark.postalCode ?? ""
            
            // Validate if geocoded location matches selected province/city
            validateLocationMatch(geocodedProvince: province, geocodedCity: city)
            
            isGeocoding = false
            
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            isGeocoding = false
        }
    }
    
    private func validateLocationMatch(geocodedProvince: String, geocodedCity: String) {
        guard let selectedProvince = selectedProvinceName,
              let selectedCity = selectedCityName else {
            // No validation needed if province/city not selected
            showLocationMismatchWarning = false
            return
        }
        
        // Normalize strings for comparison
        let normalizedGeocodedProvince = normalizeLocationName(geocodedProvince)
        let normalizedSelectedProvince = normalizeLocationName(selectedProvince)
        let normalizedGeocodedCity = normalizeLocationName(geocodedCity)
        let normalizedSelectedCity = normalizeLocationName(selectedCity)
        
        // Check if province matches
        let provinceMatches = normalizedGeocodedProvince.contains(normalizedSelectedProvince) ||
                             normalizedSelectedProvince.contains(normalizedGeocodedProvince) ||
                             normalizedGeocodedProvince == normalizedSelectedProvince
        
        // Check if city matches
        let cityMatches = normalizedGeocodedCity.contains(normalizedSelectedCity) ||
                         normalizedSelectedCity.contains(normalizedGeocodedCity) ||
                         normalizedGeocodedCity == normalizedSelectedCity
        
        // Show warning if either doesn't match
        showLocationMismatchWarning = !provinceMatches || !cityMatches
        
        // Auto-hide warning after 5 seconds
        if showLocationMismatchWarning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.showLocationMismatchWarning = false
            }
        }
    }
    
    private func normalizeLocationName(_ name: String) -> String {
        return name.lowercased()
            .replacingOccurrences(of: "provinsi ", with: "")
            .replacingOccurrences(of: "daerah istimewa ", with: "")
            .replacingOccurrences(of: "kota ", with: "")
            .replacingOccurrences(of: "kabupaten ", with: "")
            .replacingOccurrences(of: "kab. ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - MapView (UIViewRepresentable)

struct MapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    @Binding var isDragging: Bool
    var onRegionChange: (MKCoordinateRegion) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if !context.coordinator.isUserInteracting {
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var isUserInteracting = false
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            // Check if user is interacting
            if mapView.isUserInteractionEnabled {
                isUserInteracting = true
                parent.isDragging = true
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
            parent.onRegionChange(mapView.region)
            
            // Reset dragging state after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isUserInteracting = false
                self.parent.isDragging = false
            }
        }
    }
}
