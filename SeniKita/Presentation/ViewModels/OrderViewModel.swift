//
//  OrderViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

@MainActor
class OrderViewModel: ObservableObject {
    
    private let orderRepository: OrderRepositoryProtocol
    
    @Published var orders: [OrderHistory] = []
    @Published var serviceOrders: [OrderServiceHistory] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(orderRepository: OrderRepositoryProtocol? = nil) {
        self.orderRepository = orderRepository ?? DIContainer.shared.orderRepository
    }
    
    func fetchOrders() {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let orders = try await orderRepository.getOrderHistory()
                self.orders = orders
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func fetchServiceOrders() {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let orders = try await orderRepository.getServiceOrderHistory()
                self.serviceOrders = orders
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func cancelOrder(orderId: Int, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token")
            return
        }
        isLoading = true
        
        Task {
            do {
                try await orderRepository.cancelOrder(id: orderId)
                self.isLoading = false
                self.fetchOrders()
                completion(true, "Pesanan berhasil dibatalkan")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func confirmReceived(orderId: Int, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token")
            return
        }
        isLoading = true
        
        Task {
            do {
                try await orderRepository.confirmOrder(id: orderId)
                self.isLoading = false
                self.fetchOrders()
                completion(true, "Pesanan dikonfirmasi diterima")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
}
