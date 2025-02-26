//
//  ProfileViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import Foundation
import Alamofire

@MainActor
class ProfileViewModel: ObservableObject {
    
    private let baseUrl = "https://api.senikita.my.id/api/auth"
    
    @Published var profile: User?
    @Published var isLoading: Bool = false
    
    init() {
        getProfile()
    }
    
    func getProfile() {
        isLoading = true
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            print("No auth token found")
            isLoading = false
            return
        }
        
        let url = "\(baseUrl)/profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                switch response.result {
                case .success(let data):
                    do {
                        let profileResponse = try JSONDecoder().decode(Auth.self, from: data)
                        
                        Task { @MainActor in
                            self?.profile = profileResponse.user
                        }
                        
                    } catch {
                        print("JSON decoding failed: \(error)")
                    }
                    
                case .failure(let error):
                    print("Request failed: \(error.localizedDescription)")
                }
            }
    }
}
