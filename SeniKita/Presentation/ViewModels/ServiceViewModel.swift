//
//  ServiceViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

@MainActor
class ServiceViewModel: ObservableObject {
    
    private let serviceRepository: ServiceRepositoryProtocol
    
    @Published var service: ServiceData? = nil
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init(serviceRepository: ServiceRepositoryProtocol? = nil) {
        self.serviceRepository = serviceRepository ?? DIContainer.shared.serviceRepository
    }
    
    func fetchServiceById(idService: Int, isLoad: Bool) {
        if isLoad { isLoading = true }
        
        Task {
            do {
                let service = try await serviceRepository.getServiceDetail(id: idService)
                self.service = service
                
                if let category = service.category {
                    self.categories = [category]
                } else {
                    self.categories = []
                }
                
                if let shop = service.shop {
                    self.shops = [shop]
                    if let city = shop.city {
                        self.cities = [city]
                        if let province = city.province {
                            self.provinces = [province]
                        } else {
                            self.provinces = []
                        }
                    } else {
                        self.cities = []
                        self.provinces = []
                    }
                } else {
                    self.shops = []
                    self.cities = []
                    self.provinces = []
                }
                
                self.isLoading = false
            } catch {
                self.errorMessage = "Error fetching service detail: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
