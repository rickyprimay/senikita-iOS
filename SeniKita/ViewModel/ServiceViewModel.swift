//
//  ServiceViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 10/03/25.
//

import Foundation
import Alamofire

class ServiceViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var service: ServiceData? = nil
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {
        
    }
    
    func fetchServiceById(idService: Int, isLoad: Bool) {
        
        if isLoad {
            isLoading = true
        }
        
        guard let url = URL(string: baseUrl + "service/\(idService)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: ServiceDetailResponse.self) { [weak self] response in
        DispatchQueue.main.async {
            self?.isLoading = false
            switch response.result {
            case .success(let serviceResponse):
                let service = serviceResponse.service
                self?.service = service
                self?.categories = [service.category].compactMap { $0 }
                self?.shops = [service.shop].compactMap { $0 }
                self?.cities = service.shop?.city != nil ? [service.shop!.city!] : []
                self?.provinces = service.shop?.city?.province != nil ? [service.shop!.city!.province!] : []
            case .failure(let error):
                self?.errorMessage = "Error fetchign procut \(error.localizedDescription)"
                
            }
        }
    }
        
    }
}

