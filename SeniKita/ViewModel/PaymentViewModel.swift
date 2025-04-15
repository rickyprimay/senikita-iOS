//
//  PaymentViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 22/03/25.
//

import Foundation
import Alamofire

@MainActor
class PaymentViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    @Published var isLoading: Bool = false
    @Published var ongkir: [Ongkir] = []
    @Published var firstAddress: Address?
    @Published var address: [Address] = []
    @Published var city: [City] = []
    @Published var province: [Province] = []
    @Published var cityByProvince: [City] = []
    @Published var detailAddress: Address?
    @Published var isAddressLoaded = false
    @Published var isCheckoutSuccess: Bool = false
    
    func getOngkirCost(originId: Int, destination: Int, completion: @escaping (Bool, String) -> Void) {
        
        DispatchQueue.main.async { self.isLoading = true }
        
        let url = "\(baseUrl)check-ongkir"
        
        let parameters: [String: Any] = [
            "origin": originId,
            "destination": destination,
            "weight": 1000,
            "courier": "jne"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ])
        .validate(statusCode: 200..<300)
        .responseData { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }

            switch response.result {
            case .success(let data):
                let jsonString = String(data: data, encoding: .utf8)
                do {
                    let decodedResponse = try JSONDecoder().decode(OngkirResponse.self, from: data)
                    DispatchQueue.main.async {
                        let ongkirData = decodedResponse.data
                        self.ongkir = ongkirData
                    }
                    completion(true, "Post and Fetching data ongkir success")
                } catch {
                    completion(false, "Failed to decode JSON")
                }
            case .failure(let error):
                let errorMessage = error.localizedDescription
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Server Error JSON: \(jsonString)")
                }
                completion(false, errorMessage)
            }
        }
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
                                    if !self.address.isEmpty {
                                        self.firstAddress = self.address[0]
                                    } else {
                                        print("Address list is empty")
                                    }
                                    self.isAddressLoaded = true
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
    
    func makeCheckout(productIDs: [Int], qtys: [Int], courier: String, service: String, addressID: Int, note: String) {
        DispatchQueue.main.async { self.isLoading = true }

        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }

        let url = "\(baseUrl)user/order"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "product_ids": productIDs,
            "qtys": qtys,
            "courier": "JNE",
            "service": service,
            "address_id": addressID,
            "note": note
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async { self.isLoading = false }

                switch response.result {
                case .success(let data):
                    print("Order success: \(String(data: data, encoding: .utf8) ?? "")")
                    DispatchQueue.main.async {
                        self.isCheckoutSuccess = true
                    }
                case .failure(let error):
                    print("Order failed: \(error.localizedDescription)")
                    if let data = response.data {
                        print("Server response: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                }
            }
    }
}
