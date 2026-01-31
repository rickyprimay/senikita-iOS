//
//  CartViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

@MainActor
class CartViewModel: ObservableObject {
    
    private let cartRepository: CartRepositoryProtocol
    
    @Published var cart: [Cart] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var totalItems: Int { cart.count }
    
    var totalPrice: Double {
        cart.reduce(0) { $0 + ($1.productPrice * Double($1.qty)) }
    }
    
    var totalQuantity: Int {
        cart.reduce(0) { $0 + $1.qty }
    }
    
    var isEmpty: Bool { cart.isEmpty }
    
    init(cartRepository: CartRepositoryProtocol? = nil) {
        self.cartRepository = cartRepository ?? DIContainer.shared.cartRepository
        fetchCart()
    }
    
    func fetchCart() {
        isLoading = true
        
        guard DIContainer.shared.isAuthenticated else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let cartItems = try await cartRepository.getCart()
                self.cart = cartItems
                self.isLoading = false
            } catch {
                self.errorMessage = "Failed to fetch cart: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func addToCart(productId: Int, quantity: Int = 1, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        
        guard DIContainer.shared.isAuthenticated else {
            isLoading = false
            completion(false, "No authentication token")
            return
        }
        
        Task {
            do {
                try await cartRepository.addToCart(productId: productId, quantity: quantity)
                self.fetchCart()
                completion(true, "Berhasil menambahkan ke keranjang")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func incrementItem(cartItemId: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        
        Task {
            do {
                try await cartRepository.incrementItem(cartItemId: cartItemId)
                self.fetchCart()
            } catch {
                print("Error incrementing item: \(error)")
            }
        }
    }
    
    func decrementItem(cartItemId: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        
        Task {
            do {
                try await cartRepository.decrementItem(cartItemId: cartItemId)
                self.fetchCart()
            } catch {
                print("Error decrementing item: \(error)")
            }
        }
    }
    
    func removeItem(cartItemId: Int, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token")
            return
        }
        
        Task {
            do {
                try await cartRepository.removeItem(cartItemId: cartItemId)
                self.fetchCart()
                completion(true, "Berhasil menghapus dari keranjang")
            } catch {
                completion(false, error.localizedDescription)
            }
        }
    }
}
