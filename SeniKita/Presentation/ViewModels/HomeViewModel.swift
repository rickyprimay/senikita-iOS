//
//  HomeViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    private let productRepository: ProductRepositoryProtocol
    private let serviceRepository: ServiceRepositoryProtocol
    private let cartRepository: CartRepositoryProtocol
    
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var products: [ProductData] = []
    @Published var services: [ServiceData] = []
    @Published var searchedProducts: [ProductData] = []
    @Published var searchedServices: [ServiceData] = []
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var cart: [Cart] = []
    @Published var totalCart: Int = 0
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    @Published var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }
    
    var displayProducts: [ProductData] {
        searchText.isEmpty ? products : searchedProducts
    }
    
    var displayServices: [ServiceData] {
        searchText.isEmpty ? services : searchedServices
    }
    
    init(
        productRepository: ProductRepositoryProtocol? = nil,
        serviceRepository: ServiceRepositoryProtocol? = nil,
        cartRepository: CartRepositoryProtocol? = nil
    ) {
        let container = DIContainer.shared
        self.productRepository = productRepository ?? container.productRepository
        self.serviceRepository = serviceRepository ?? container.serviceRepository
        self.cartRepository = cartRepository ?? container.cartRepository
        
        fetchProducts(isLoad: true)
    }
    
    private func debounceSearch() {
        searchTask?.cancel()
        
        guard !searchText.isEmpty else {
            searchedProducts = []
            searchedServices = []
            isSearching = false
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            guard !Task.isCancelled else { return }
            
            await performSearch(query: searchText)
        }
    }
    
    private func performSearch(query: String) async {
        isSearching = true
        
        do {
            async let productsResult = productRepository.searchProducts(query: query)
            async let servicesResult = serviceRepository.searchServices(query: query)
            
            let (products, services) = try await (productsResult, servicesResult)
            
            guard !Task.isCancelled else { return }
            
            self.searchedProducts = products
            self.searchedServices = services
            self.isSearching = false
        } catch {
            guard !Task.isCancelled else { return }
            self.isSearching = false
            print("Search error: \(error.localizedDescription)")
        }
    }
    
    func fetchProducts(isLoad: Bool) {
        if isLoad { isLoading = true }
        
        Task {
            do {
                let products = try await productRepository.getProducts()
                self.products = products
                
                let uniqueCategories = products.compactMap { $0.category }
                let uniqueCategoryIDs = Array(Set(uniqueCategories.map { $0.id }))
                self.categories = uniqueCategoryIDs.compactMap { id in
                    uniqueCategories.first(where: { $0.id == id })
                }
                
                let uniqueShops = products.compactMap { $0.shop }
                let uniqueShopIDs = Array(Set(uniqueShops.compactMap { $0.id }))
                self.shops = uniqueShopIDs.compactMap { id in
                    uniqueShops.first(where: { $0.id == id })
                }
                
                let uniqueCities = self.shops.compactMap { $0.city }
                let uniqueCityIDs = Array(Set(uniqueCities.map { $0.id }))
                self.cities = uniqueCityIDs.compactMap { id in
                    uniqueCities.first(where: { $0.id == id })
                }
                
                fetchServices(isLoad: false)
                
            } catch {
                self.errorMessage = "Error fetching products: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func fetchServices(isLoad: Bool) {
        if isLoad { isLoading = true }
        
        Task {
            do {
                let services = try await serviceRepository.getServices()
                self.services = services
                fetchCart()
            } catch {
                self.errorMessage = "Error fetching services: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func fetchCart() {
        guard DIContainer.shared.isAuthenticated else { 
            isLoading = false
            return 
        }
        
        Task {
            do {
                let cartItems = try await cartRepository.getCart()
                self.cart = cartItems
                self.totalCart = cartItems.count
                self.isLoading = false
            } catch {
                print("Failed to fetch cart: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func addToCart(idProduct: Int, qty: Int, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token")
            return
        }
        
        Task {
            do {
                try await cartRepository.addToCart(productId: idProduct, quantity: qty)
                fetchCart()
                completion(true, "Berhasil menambahkan ke keranjang")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func addProductToCart(productId: Int, isLoad: Bool, completion: @escaping (Bool, String) -> Void) {
        addToCart(idProduct: productId, qty: 1, completion: completion)
    }
    
    func incrementCart(cartItemId: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        
        if let index = cart.firstIndex(where: { $0.cart_item_id == cartItemId }) {
            let originalQty = cart[index].qty
            cart[index].qty += 1
            
            Task {
                do {
                    try await cartRepository.incrementItem(cartItemId: cartItemId)
                } catch {
                    if let idx = self.cart.firstIndex(where: { $0.cart_item_id == cartItemId }) {
                        self.cart[idx].qty = originalQty
                    }
                    print("Error incrementing cart: \(error)")
                }
            }
        }
    }
    
    func decrementCart(cartItemId: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        
        if let index = cart.firstIndex(where: { $0.cart_item_id == cartItemId }) {
            let originalQty = cart[index].qty
            
            if originalQty > 1 {
                cart[index].qty -= 1
                
                Task {
                    do {
                        try await cartRepository.decrementItem(cartItemId: cartItemId)
                    } catch {
                        if let idx = self.cart.firstIndex(where: { $0.cart_item_id == cartItemId }) {
                            self.cart[idx].qty = originalQty
                        }
                        print("Error decrementing cart: \(error)")
                    }
                }
            }
        }
    }
    
    func deleteCart(cartItemId: Int, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token")
            return
        }
        
        let originalCart = cart
        cart.removeAll { $0.cart_item_id == cartItemId }
        totalCart = cart.count
        
        Task {
            do {
                try await cartRepository.removeItem(cartItemId: cartItemId)
                completion(true, "Berhasil menghapus dari keranjang")
            } catch {
                self.cart = originalCart
                self.totalCart = originalCart.count
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func showPopup(message: String, isSuccess: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("ShowPopup"), object: nil, userInfo: ["message": message, "isSuccess": isSuccess])
        }
    }
    
    func deleteCartByIdItem(cartItemId: Int) {
        deleteCart(cartItemId: cartItemId) { _, _ in }
    }
    
    func getCartProduct(isLoad: Bool) {
        fetchCart()
    }
    
    func incrementQuantity(cartItemId: Int) {
        incrementCart(cartItemId: cartItemId)
    }
    
    func decrementQuantity(cartItemId: Int) {
        decrementCart(cartItemId: cartItemId)
    }
}
