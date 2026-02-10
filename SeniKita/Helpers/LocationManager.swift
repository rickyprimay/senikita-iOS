//
//  LocationManager.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 08/02/26.
//

import Foundation
import CoreLocation
import Combine

/// Manager class to handle location services and permissions
@MainActor
class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current user location coordinate
    @Published var currentLocation: CLLocationCoordinate2D?
    
    /// Current authorization status for location services
    @Published var authorizationStatus: CLAuthorizationStatus
    
    /// Error message if location services fail
    @Published var errorMessage: String?
    
    /// Loading state while fetching location
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    
    private let locationManager: CLLocationManager
    
    // MARK: - Initialization
    
    override init() {
        self.locationManager = CLLocationManager()
        self.authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
    }
    
    // MARK: - Public Methods
    
    /// Request location permission from user
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Get current user location
    func getCurrentLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            errorMessage = "Izin lokasi belum diberikan. Silakan aktifkan di Pengaturan."
            return
        }
        
        isLoading = true
        errorMessage = nil
        locationManager.requestLocation()
    }
    
    /// Check if location services are available
    var isLocationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// Check if app has location permission
    var hasLocationPermission: Bool {
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        // Automatically fetch location when permission is granted
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            getCurrentLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLocation = location.coordinate
        isLoading = false
        errorMessage = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                errorMessage = "Izin lokasi ditolak. Silakan aktifkan di Pengaturan."
            case .locationUnknown:
                errorMessage = "Lokasi tidak dapat ditemukan. Coba lagi."
            case .network:
                errorMessage = "Koneksi jaringan bermasalah. Periksa koneksi Anda."
            default:
                errorMessage = "Gagal mendapatkan lokasi: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "Gagal mendapatkan lokasi: \(error.localizedDescription)"
        }
    }
}
