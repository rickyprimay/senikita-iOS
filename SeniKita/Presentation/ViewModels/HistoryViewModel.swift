//
//  HistoryViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

@MainActor
class HistoryViewModel: ObservableObject {
    
    private let orderRepository: OrderRepositoryProtocol
    
    @Published var history: [OrderHistory] = []
    @Published var historyProductDetail: OrderHistory?
    @Published var historyService: [OrderServiceHistory] = []
    @Published var historyServiceDetail: OrderServiceHistory?
    @Published var isLoading: Bool = false
    private var hasFetchedServiceHistory = false
    
    init(orderRepository: OrderRepositoryProtocol? = nil) {
        self.orderRepository = orderRepository ?? DIContainer.shared.orderRepository
        gethistoryProduct()
    }
    
    func gethistoryProduct() {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let orders = try await orderRepository.getOrderHistory()
                self.history = orders
                self.isLoading = false
            } catch {
                print("Failed to fetch history product data: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getDetailHistoryProduct(idHistory: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let order = try await orderRepository.getOrderDetail(id: idHistory)
                self.historyProductDetail = order
                self.isLoading = false
            } catch {
                print("Failed to fetch history product detail: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getHistoryService() {
        guard !hasFetchedServiceHistory else { return }
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let orders = try await orderRepository.getServiceOrderHistory()
                self.historyService = orders
                self.hasFetchedServiceHistory = true
                self.isLoading = false
            } catch {
                print("Failed to fetch history service data: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func getDetailHistoryService(idHistory: Int) {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let order = try await orderRepository.getServiceOrderDetail(id: idHistory)
                self.historyServiceDetail = order
                self.isLoading = false
            } catch {
                print("Failed to fetch history service detail: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func submitRating(transactionId: Int, productId: Int, rating: Int, review: String, images: [Data]?, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token found")
            return
        }
        isLoading = true
        
        Task {
            do {
                try await orderRepository.submitRating(
                    transactionId: transactionId,
                    productId: productId,
                    rating: rating,
                    review: review,
                    images: images
                )
                self.isLoading = false
                completion(true, "Rating berhasil dikirim")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func submitServiceRating(transactionId: Int, serviceId: Int, rating: Int, review: String, images: [Data]?, completion: @escaping (Bool, String) -> Void) {
        guard DIContainer.shared.isAuthenticated else {
            completion(false, "No authentication token found")
            return
        }
        isLoading = true
        
        Task {
            do {
                try await orderRepository.submitServiceRating(
                    transactionId: transactionId,
                    serviceId: serviceId,
                    rating: rating,
                    review: review,
                    images: images
                )
                self.isLoading = false
                completion(true, "Rating berhasil dikirim")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
}
