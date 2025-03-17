//
//  AddressViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 17/03/25.
//

import Foundation
import Alamofire

class AddressViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var isLoading: Bool = false
    @Published var address: [Address] = []
    @Published var city: [City] = []
    @Published var province: [Province] = []
    @Published var cityByProvince: [City] = []
    
    init() {
        
    }
    
    func getAddress() {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)user/address"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated)
            .async {
                AF.request(url, method: .get, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseData { [weak self] response in
                        guard let self = self else { return }
                        DispatchQueue.main.async { self.isLoading = false }
                        
                        switch response.result {
                        case .success(let data):
                            do {
                                let addressResponse = try JSONDecoder().decode(AddressResponse.self, from: data)
                                DispatchQueue.main.async {
                                    self.address = addressResponse.data
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    print("Failed to parse Address data: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                print("Failed to fetch address data : \(error.localizedDescription)")
                                
                                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                    print("Server Error JSON: \(jsonString)")
                                }
                            }
                        }
                    }
            }
    }
    
    func getCities(){
        
        isLoading = true
        guard let url = URL(string: baseUrl + "cities") else {
            self.isLoading = false
            return
        }
        
        AF.request(url)
            .responseDecodable(of: CityResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.city = result.cities
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                    self.isLoading = false
                }
            }
        
    }
    
    func getProvinces(){
        
        isLoading = true
        guard let url = URL(string: baseUrl + "provinces") else {
            self.isLoading = false
            return
        }
        
        AF.request(url)
            .responseDecodable(of: ProvinceResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.province = result.provinces
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                    self.isLoading = false
                }
            }
        
    }
    
    func getCitiesByIdProvinces(idProvinces: Int) {
        
        isLoading = true
        guard let url = URL(string: baseUrl + "cities-by-province/\(idProvinces)") else {
            self.isLoading = false
            return
        }
        
        AF.request(url)
            .responseDecodable(of: CityResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.cityByProvince = result.cities
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                    self.isLoading = false
                }
            }
        
    }
    
}
