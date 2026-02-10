//
//  AddressViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import CoreLocation

@MainActor
class AddressViewModel: ObservableObject {
    
    private let addressRepository: AddressRepositoryProtocol
    
    @Published var isLoading: Bool = false
    @Published var isLoadingProvinces: Bool = false
    @Published var isLoadingCities: Bool = false
    @Published var address: [Address] = []
    @Published var city: [City] = []
    @Published var province: [Province] = []
    @Published var cityByProvince: [City] = []
    @Published var detailAddress: Address?
    
    // Geocoding properties
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var isGeocodingLoading: Bool = false
    @Published var geocodingError: String?
    
    init(addressRepository: AddressRepositoryProtocol? = nil) {
        self.addressRepository = addressRepository ?? DIContainer.shared.addressRepository
    }
    
    func getAddress() {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let addresses = try await addressRepository.getAddresses()
                self.address = addresses
                self.isLoading = false
            } catch {
                print("Failed to fetch address data: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getAddressById(idAddress: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let address = try await addressRepository.getAddressDetail(id: idAddress)
                self.detailAddress = address
                self.isLoading = false
            } catch {
                print("Failed to fetch address data: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func addAddress(
        labelAddress: String,
        name: String,
        phone: String,
        addressDetail: String,
        provinceId: Int,
        cityId: Int,
        postalCode: String,
        note: String?,
        completion: @escaping (Bool, String) -> Void
    ) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "Token tidak ditemukan")
            return
        }
        isLoading = true
        
        Task {
            do {
                _ = try await addressRepository.createAddress(
                    labelAddress: labelAddress,
                    name: name,
                    phone: phone,
                    provinceId: provinceId,
                    cityId: cityId,
                    addressDetail: addressDetail,
                    postalCode: postalCode,
                    note: note,
                    isDefault: false
                )
                
                self.isLoading = false
                completion(true, "Alamat berhasil ditambahkan")
                self.getAddress()
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func updateAddress(
        idAddress: Int,
        labelAddress: String,
        name: String,
        phone: String,
        addressDetail: String,
        provinceId: Int,
        cityId: Int,
        postalCode: String,
        note: String?,
        completion: @escaping (Bool, String) -> Void
    ) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "Token tidak ditemukan")
            return
        }
        isLoading = true
        
        Task {
            do {
                _ = try await addressRepository.updateAddress(
                    id: idAddress,
                    labelAddress: labelAddress,
                    name: name,
                    phone: phone,
                    provinceId: provinceId,
                    cityId: cityId,
                    addressDetail: addressDetail,
                    postalCode: postalCode,
                    note: note,
                    isDefault: false
                )
                
                self.isLoading = false
                completion(true, "Alamat berhasil diupdate")
                self.getAddress()
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func deleteAddress(idAddress: Int, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "Token tidak ditemukan")
            return
        }
        isLoading = true
        
        Task {
            do {
                try await addressRepository.deleteAddress(id: idAddress)
                self.isLoading = false
                completion(true, "Alamat berhasil dihapus")
                self.getAddress()
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func getCities() {
        isLoading = true
        Task {
            do {
                let cities = try await addressRepository.getCities()
                self.city = cities
                self.isLoading = false
            } catch {
                print("error: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getProvinces() {
        isLoadingProvinces = true
        Task {
            do {
                let provinces = try await addressRepository.getProvinces()
                self.province = provinces
                self.isLoadingProvinces = false
            } catch {
                print("error: \(error.localizedDescription)")
                self.isLoadingProvinces = false
            }
        }
    }
    
    func getCitiesByProvince(provinceId: Int) {
        isLoading = true
        Task {
            do {
                let cities = try await addressRepository.getCitiesByProvince(provinceId: provinceId)
                self.cityByProvince = cities
                self.isLoading = false
            } catch {
                print("error: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getCitiesByIdProvinces(idProvinces: Int, completion: @escaping () -> Void) {
        isLoadingCities = true
        cityByProvince = []
        Task {
            do {
                let cities = try await addressRepository.getCitiesByProvince(provinceId: idProvinces)
                self.cityByProvince = cities
                self.isLoadingCities = false
                completion()
            } catch {
                print("error: \(error.localizedDescription)")
                self.isLoadingCities = false
                completion()
            }
        }
    }
    
    // MARK: - Geocoding Methods
    
    /// Perform reverse geocoding to get address details from coordinates
    func reverseGeocode(
        coordinate: CLLocationCoordinate2D,
        completion: @escaping (String?, String?, String?, String?) -> Void
    ) {
        isGeocodingLoading = true
        geocodingError = nil
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        Task {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                
                guard let placemark = placemarks.first else {
                    self.isGeocodingLoading = false
                    self.geocodingError = "Alamat tidak ditemukan"
                    completion(nil, nil, nil, nil)
                    return
                }
                
                // Extract address components
                let street = placemark.thoroughfare ?? ""
                let subLocality = placemark.subLocality ?? ""
                let addressDetail = [street, subLocality].filter { !$0.isEmpty }.joined(separator: ", ")
                
                let province = placemark.administrativeArea ?? ""
                let city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                
                self.isGeocodingLoading = false
                completion(addressDetail, province, city, postalCode)
                
            } catch {
                self.isGeocodingLoading = false
                self.geocodingError = "Gagal mendapatkan alamat: \(error.localizedDescription)"
                completion(nil, nil, nil, nil)
            }
        }
    }
    
    /// Match province name from geocoding with backend province data
    func matchProvince(name: String) -> Province? {
        let normalizedName = name.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Try exact match first
        if let match = province.first(where: { $0.name.lowercased() == normalizedName }) {
            return match
        }
        
        // Try contains match
        if let match = province.first(where: { $0.name.lowercased().contains(normalizedName) || normalizedName.contains($0.name.lowercased()) }) {
            return match
        }
        
        // Special cases for common variations
        let specialCases: [String: String] = [
            "dki jakarta": "jakarta",
            "jakarta raya": "jakarta",
            "yogyakarta": "daerah istimewa yogyakarta",
            "di yogyakarta": "daerah istimewa yogyakarta",
            "aceh": "nanggroe aceh darussalam"
        ]
        
        if let mappedName = specialCases[normalizedName] {
            return province.first(where: { $0.name.lowercased().contains(mappedName) })
        }
        
        return nil
    }
    
    /// Match city name from geocoding with backend city data for a specific province
    func matchCity(name: String, provinceId: Int) -> City? {
        let normalizedName = name.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Try exact match first
        if let match = cityByProvince.first(where: { $0.name.lowercased() == normalizedName }) {
            return match
        }
        
        // Try contains match
        if let match = cityByProvince.first(where: { $0.name.lowercased().contains(normalizedName) || normalizedName.contains($0.name.lowercased()) }) {
            return match
        }
        
        // Try removing common prefixes
        let prefixes = ["kota ", "kabupaten ", "kab. ", "kab "]
        for prefix in prefixes {
            let withoutPrefix = normalizedName.replacingOccurrences(of: prefix, with: "")
            if let match = cityByProvince.first(where: { $0.name.lowercased().contains(withoutPrefix) || withoutPrefix.contains($0.name.lowercased()) }) {
                return match
            }
        }
        
        return nil
    }
}

