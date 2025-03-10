//
//  HomeViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation
import Alamofire

class HomeViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var products: [ProductData] = []
    @Published var services: [ServiceResult] = []
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {
        fetchProducts(isLoad: true)
    }
    
    func fetchProducts(isLoad: Bool) {
        if isLoad{
            isLoading = true
        }
        guard let url = URL(string: baseUrl + "products") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Product.self) { [weak self] response in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch response.result {
                    case .success(let productResponse):
                        self?.products = productResponse.data.data
                        self?.categories = productResponse.data.data.compactMap { $0.category }
                        self?.shops = productResponse.data.data.compactMap { $0.shop }
                        self?.cities = self?.shops.compactMap { $0.city } ?? []
                        self?.provinces = self?.cities.compactMap { $0.province } ?? []
                        self?.fetchServices(isLoad: false)
                    case .failure(let error):
                        self?.errorMessage = "Error fetching products: \(error.localizedDescription)"
                        print("Error fetching products: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func fetchServices(isLoad: Bool) {
        if isLoad{
            isLoading = true
        }
        guard let url = URL(string: baseUrl + "service") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: ServiceResponse.self) { [weak self] response in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch response.result {
                    case .success(let serviceResponse):
                        self?.services = serviceResponse.data.data
                    case .failure(let error):
                        self?.errorMessage = "Error fetching services: \(error.localizedDescription)"
                        print("Error fetching services: \(error.localizedDescription)")
                    }
                }
            }
    }
}
