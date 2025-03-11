//
//  ProductViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import Foundation
import Alamofire

class ProductViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var product: ProductData? = nil
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var shops: [Shop] = []
    @Published var provinces: [Province] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {}
    
    func fetchProductById(idProduct: Int, isLoad: Bool) {
        if isLoad {
            DispatchQueue.main.async { self.isLoading = true }
        }
        
        guard let url = URL(string: baseUrl + "products/\(idProduct)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url)
                .validate()
                .responseDecodable(of: ProductDetailResponse.self) { [weak self] response in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        switch response.result {
                        case .success(let productResponse):
                            let product = productResponse.product
                            self?.product = product
                            self?.categories = [product.category].compactMap { $0 }
                            self?.shops = [product.shop].compactMap { $0 }
                            self?.cities = product.shop?.city != nil ? [product.shop!.city!] : []
                            self?.provinces = product.shop?.city?.province != nil ? [product.shop!.city!.province!] : []
                        case .failure(let error):
                            self?.errorMessage = "Error fetching product \(error.localizedDescription)"
                        }
                    }
                }
        }
    }
}
