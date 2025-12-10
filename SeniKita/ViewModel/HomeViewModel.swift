//
//  HomeViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation
import Alamofire
import SwiftUI

class HomeViewModel: ObservableObject {
    
    let baseUrl = "https://senikita.sirekampolkesyogya.my.id/api/"
    
    @Published var products: [ProductData] = []
    @Published var services: [ServiceData] = []
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var cart: [Cart] = []
    @Published var totalCart: Int = 0
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {
        fetchProducts(isLoad: true)
    }
    
    func fetchProducts(isLoad: Bool) {
        if isLoad {
            DispatchQueue.main.async { self.isLoading = true }
        }
        
        guard let url = URL(string: baseUrl + "products") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url)
                .validate()
                .responseDecodable(of: Product.self) { [weak self] response in
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("RAW PRODUCTS RESPONSE: \(raw)")
                    }
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        switch response.result {
                        case .success(let productResponse):
                            print("✅ Products fetched successfully: \(productResponse.data.data.count) items")
                            self?.products = productResponse.data.data
                            
                            let uniqueCategories = productResponse.data.data.compactMap { $0.category }
                            self?.categories = Array(Set(uniqueCategories.map { $0.id })).compactMap { id in
                                uniqueCategories.first(where: { $0.id == id })
                            }
                            
                            let uniqueShops = productResponse.data.data.compactMap { $0.shop }
                            self?.shops = Array(Set(uniqueShops.compactMap { $0.id })).compactMap { id in
                                uniqueShops.first(where: { $0.id == id })
                            }
                            
                            let uniqueCities = self?.shops.compactMap { $0.city } ?? []
                            self?.cities = Array(Set(uniqueCities.map { $0.id })).compactMap { id in
                                uniqueCities.first(where: { $0.id == id })
                            }
                            
                            let uniqueProvinces = self?.cities.compactMap { $0.province } ?? []
                            self?.provinces = Array(Set(uniqueProvinces.map { $0.id })).compactMap { id in
                                uniqueProvinces.first(where: { $0.id == id })
                            }
                            
                            self?.fetchServices(isLoad: false)
                        case .failure(let error):
                            self?.errorMessage = "Error fetching products: \(error.localizedDescription)"
                            print("❌ Error fetching products: \(error.localizedDescription)")
                            if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                                print("Error response: \(errorString)")
                            }
                        }
                    }
                }
        }
    }
    
    func fetchServices(isLoad: Bool) {
        if isLoad {
            DispatchQueue.main.async { self.isLoading = true }
        }
        
        guard let url = URL(string: baseUrl + "service") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url)
                .validate()
                .responseDecodable(of: ServiceResponse.self) { [weak self] response in
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("RAW SERVICES RESPONSE: \(raw)")
                    }
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        switch response.result {
                        case .success(let serviceResponse):
                            print("✅ Services fetched successfully: \(serviceResponse.data.data.count) items")
                            self?.services = serviceResponse.data.data
                        case .failure(let error):
                            self?.errorMessage = "Error fetching services: \(error.localizedDescription)"
                            print("❌ Error fetching services: \(error.localizedDescription)")
                            if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                                print("Error response: \(errorString)")
                            }
                        }
                    }
                }
        }
    }
    
    func addProductToCart(productId: Int, isLoad: Bool, completion: @escaping (Bool, String) -> Void) {
        
        DispatchQueue.main.async { self.isLoading = true }
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)user/cart/items"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
        ]
        
        let parameters: [String: Any] = [
            "product_id": productId,
            "qty": 1
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("RAW ADD CART RESPONSE: \(raw)")
                }
                guard let self = self else { return }
                DispatchQueue.main.async { self.isLoading = false }
                
                switch response.result {
                case .success:
                    completion(true, "Produk berhasil ditambahkan ke keranjang")
                case .failure(let error):
                    let errorMessage = error.localizedDescription
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Server Error JSON: \(jsonString)")
                    }
                    completion(false, errorMessage)
                }
                
            }
        
    }
    
    func showPopup(message: String, isSuccess: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("ShowPopup"), object: nil, userInfo: ["message": message, "isSuccess": isSuccess])
        }
    }
    
    func getCartProduct(isLoad: Bool) {
        if isLoad {
            DispatchQueue.main.async { self.isLoading = true }
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        guard let url = URL(string: baseUrl + "user/cart") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: CartResponse.self) { [weak self] response in
                    if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                        print("RAW CART LIST RESPONSE: \(raw)")
                    }
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        switch response.result {
                        case .success(let cartResponse):
                            self?.cart = cartResponse.data
                            self?.totalCart = cartResponse.data.count
                        case .failure(let error):
                            self?.errorMessage = "Error fetching cart item: \(error.localizedDescription)"
                            print("Error fetching cart item: \(error.localizedDescription)")
                        }
                    }
                }
        }
    }
    
    func incrementQuantity(cartItemId: Int) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            print("Auth token is missing or empty.")
            return
        }

        let url = "\(baseUrl)user/cart/items/increment/\(cartItemId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
        ]

        AF.request(url, method: .put, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("RAW INCREMENT RESPONSE: \(raw)")
                }
                switch response.result {
                case .success:
                    print("increment success")
                case .failure(let error):
                    print("Error incrementing quantity: \(error.localizedDescription)")
                    if let data = response.data, let errorResponse = String(data: data, encoding: .utf8) {
                        print("Error Response: \(errorResponse)")
                    }
                }
            }
    }

    func decrementQuantity(cartItemId: Int) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else { return }

        let url = "\(baseUrl)user/cart/items/decrement/\(cartItemId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
        ]

        AF.request(url, method: .put, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("RAW DECREMENT RESPONSE: \(raw)")
                }
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        print("decrement success")
                    }
                case .failure(let error):
                    print("Error decrementing quantity: \(error.localizedDescription)")
                }
            }
    }
    
    func deleteCartByIdItem(cartItemId: Int) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else { return }

        let url = "\(baseUrl)user/cart/items/\(cartItemId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
        ]

        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("RAW DELETE CART RESPONSE: \(raw)")
                }
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        print("delete cart item success")
                        self.getCartProduct(isLoad: true)
                    }
                case .failure(let error):
                    print("Error deleting cart item: \(error.localizedDescription)")
                }
            }
    }
}
