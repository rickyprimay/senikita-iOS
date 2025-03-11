//
//  ArtMapViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 16/02/25.
//

import Foundation
import Alamofire

class ArtMapViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var artMap: [ArtMapResult] = []
    @Published var selectedArtMap: ArtMapResult?
    @Published var singleArtMap: ArtProvinceWrapper?
    @Published var isLoading: Bool = false
    
    var errorMessage: String = ""
    
    init() {
        fetchArtMap()
    }
    
    func fetchArtMap() {
        isLoading = true
        guard let url = URL(string: baseUrl + "art-provinces") else {
            errorMessage = "Invalid URL"
            return
        }

        AF.request(url)
            .responseDecodable(of: ArtMapModel.self) { response in
                switch response.result {
                case .success(let result):
                    self.artMap = result.data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
                self.isLoading = false
            }
    }
    
    func fetchArtMapBySlug(slug: String) {
        isLoading = true
        guard let url = URL(string: baseUrl + "art-provinces/\(slug)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        AF.request(url)
            .responseDecodable(of: SingleArtMapResponse.self) { response in
                switch response.result {
                case .success(let result):
                    self.selectedArtMap = result.data.artProvince
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
                self.isLoading = false
            }
    }
}
