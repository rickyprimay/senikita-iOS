//
//  ProductViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

@MainActor
class ProductViewModel: ObservableObject {
    
    private let productRepository: ProductRepositoryProtocol
    
    @Published var product: ProductData? = nil
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init(productRepository: ProductRepositoryProtocol? = nil) {
        self.productRepository = productRepository ?? DIContainer.shared.productRepository
    }
    
    func fetchProductById(idProduct: Int, isLoad: Bool) {
        if isLoad { isLoading = true }
        
        Task {
            do {
                let product = try await productRepository.getProductDetail(id: idProduct)
                self.product = product
                self.categories = [product.category].compactMap { $0 }
                self.shops = [product.shop].compactMap { $0 }
                self.cities = product.shop?.city != nil ? [product.shop!.city!] : []
                self.provinces = product.shop?.city?.province != nil ? [product.shop!.city!.province!] : []
                self.errorMessage = nil
            } catch {
                self.errorMessage = "Error fetching product \(error.localizedDescription)"
            }
            
            if isLoad { self.isLoading = false }
        }
    }
}
