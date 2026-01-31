//
//  PaymentViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import UserNotifications

@MainActor
class PaymentViewModel: ObservableObject {
    
    private let orderRepository: OrderRepositoryProtocol
    private let addressRepository: AddressRepositoryProtocol
    
    @Published var isLoading: Bool = false
    @Published var ongkir: [Ongkir] = []
    @Published var firstAddress: Address?
    @Published var address: [Address] = []
    @Published var city: [City] = []
    @Published var province: [Province] = []
    @Published var cityByProvince: [City] = []
    @Published var detailAddress: Address?
    @Published var isAddressLoaded = false
    @Published var isCheckoutSuccess: Bool = false
    @Published var errorMessage: String?
    
    init(
        orderRepository: OrderRepositoryProtocol? = nil,
        addressRepository: AddressRepositoryProtocol? = nil
    ) {
        let container = DIContainer.shared
        self.orderRepository = orderRepository ?? container.orderRepository
        self.addressRepository = addressRepository ?? container.addressRepository
    }
    
    func getOngkirCost(originId: Int, destination: Int, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        
        Task {
            do {
                let costs = try await orderRepository.checkShippingCost(
                    origin: originId,
                    destination: destination,
                    weight: 1000,
                    courier: "jne"
                )
                
                self.ongkir = costs
                self.isLoading = false
                completion(true, "Post and Fetching data ongkir success")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func getAddress() {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let addresses = try await addressRepository.getAddresses()
                self.address = addresses
                if !self.address.isEmpty {
                    self.firstAddress = self.address[0]
                }
                self.isAddressLoaded = true
                self.isLoading = false
            } catch {
                print("Failed to fetch address data: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func makeCheckout(productIDs: [Int], qtys: [Int], courier: String, service: String, addressID: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                _ = try await orderRepository.checkout(
                    addressId: addressID,
                    shippingService: service,
                    productIds: productIDs,
                    qtys: qtys
                )
                
                self.isCheckoutSuccess = true
                self.isLoading = false
                self.sendCheckoutSuccessNotification()
                
            } catch {
                print("Order failed: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func sendCheckoutSuccessNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Checkout Berhasil!"
        content.body = "Terima kasih telah melakukan checkout. proses selanjutnya silahkan lanjutkan ke pembayaran"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
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
                    name: name,
                    phone: phone,
                    provinceId: provinceId,
                    cityId: cityId,
                    address: addressDetail,
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
    
    func getProvinces() {
        isLoading = true
        
        Task {
            do {
                let provinces = try await addressRepository.getProvinces()
                self.province = provinces
                self.isLoading = false
            } catch {
                print("error: \(error.localizedDescription)")
                self.isLoading = false
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
}
