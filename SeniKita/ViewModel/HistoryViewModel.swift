//
//  HistoryViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//

import Alamofire
import Foundation

@MainActor
class HistoryViewModel: ObservableObject {
    
    private let baseUrl = "https://api.senikita.my.id/api"
    
    @Published var history: [OrderHistory] = []
    @Published var historyProductDetail: OrderHistory?
    @Published var historyService: [OrderServiceHistory] = []
    @Published var historyServiceDetail: OrderServiceHistory?
    @Published var isLoading: Bool = false
    private var hasFetchedServiceHistory = false
    
    init() {
        gethistoryProduct()
    }
    
    func gethistoryProduct() {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)/user/transaction-history"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { [weak self] response in
                    guard let self = self else { return }
                    DispatchQueue.main.async { self.isLoading = false }
                    
                    switch response.result {
                    case .success(let data):
                        
                        do {
                            let historyProductResponse = try JSONDecoder().decode(HistoryResponse.self, from: data)
                            DispatchQueue.main.async {
                                self.history = historyProductResponse.data
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Failed to parse history product data: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("Failed to fetch history product data: \(error.localizedDescription)")
                            
                            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                print("Server Error JSON: \(jsonString)")
                            }
                        }
                    }
                }
        }
    }
    
    func getDetailHistoryProduct(idHistory: Int) {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)/user/transaction-history/\(idHistory)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { [weak self] response in
                    guard let self = self else { return }
                    DispatchQueue.main.async { self.isLoading = false }
                    
                    switch response.result {
                    case .success(let data):
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Server Response JSON: \(jsonString)")
                        }
                        
                        do {
                            let historyProductResponse = try JSONDecoder().decode(HistoryResponseDetail.self, from: data)
                            DispatchQueue.main.async {
                                self.historyProductDetail = historyProductResponse.data.order
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Failed to parse history product data: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("Failed to fetch history product data: \(error.localizedDescription)")
                            
                            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                print("Server Error JSON: \(jsonString)")
                            }
                        }
                    }
                }
        }
    }
    
    func getHistoryService() {
        guard !hasFetchedServiceHistory else { return }
        
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)/user/transaction-history-service"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { [weak self] response in
                    guard let self = self else { return }
                    DispatchQueue.main.async { self.isLoading = false }
                    
                    switch response.result {
                    case .success(let data):
                        
                        do {
                            let historyServiceResponse = try JSONDecoder().decode(HistoryServiceResponse.self, from: data)
                            DispatchQueue.main.async {
                                self.historyService = historyServiceResponse.data
                                self.hasFetchedServiceHistory = true
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Failed to parse history product data: \(error.localizedDescription)")
                            }
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("Failed to fetch history product data: \(error.localizedDescription)")
                            
                            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                print("Server Error JSON: \(jsonString)")
                            }
                        }
                    }
                }
        }
    }
    
    func getDetailHistoryService(idHistory: Int) {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)/user/transaction-history-service/\(idHistory)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { [weak self] response in
                    guard let self = self else { return }
                    DispatchQueue.main.async { self.isLoading = false }
                    
                    switch response.result {
                    case .success(let data):
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Server Response JSON: \(jsonString)")
                        }
                        
                        do {
                            let historyProductResponse = try JSONDecoder().decode(HistoryServiceResponseDetail.self, from: data)
                            DispatchQueue.main.async {
                                self.historyServiceDetail = historyProductResponse.data.order
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("Failed to parse history product data: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("Failed to fetch history product data: \(error.localizedDescription)")
                            
                            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                print("Server Error JSON: \(jsonString)")
                            }
                        }
                    }
                }
        }
    }
    
}
