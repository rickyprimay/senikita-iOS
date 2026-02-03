//
//  AddressViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

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
}
