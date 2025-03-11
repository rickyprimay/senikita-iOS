//
//  ProfileViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 26/02/25.
//

import Foundation
import UIKit
import Alamofire

@MainActor
class ProfileViewModel: ObservableObject {
    
    private let baseUrl = "https://api.senikita.my.id/api"
    
    @Published var profile: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        getProfile()
    }
    
    func getProfile() {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)/auth/profile"
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
                            let profileResponse = try JSONDecoder().decode(Auth.self, from: data)
                            DispatchQueue.main.async {
                                self.profile = profileResponse.data
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse profile data"
                            }
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to fetch profile"
                        }
                    }
                }
        }
    }
    
    func updatePassword(oldPassword: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        DispatchQueue.main.async { self.isLoading = true }
        errorMessage = nil
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            completion(false, "No authentication token found")
            return
        }
        
        let url = "\(baseUrl)/user/edit-profile/password"
        let parameters: [String: String] = [
            "old_password": oldPassword,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: PasswordUpdateResponse.self) { response in
                    DispatchQueue.main.async { self.isLoading = false }
                    
                    let statusCode = response.response?.statusCode ?? 0
                    
                    switch response.result {
                    case .success(let result):
                        if (200..<300).contains(statusCode) {
                            completion(true, result.message)
                        } else {
                            DispatchQueue.main.async { self.errorMessage = result.message }
                            completion(false, result.message)
                        }
                    case .failure:
                        completion(false, "An error occurred, please try again.")
                    }
                }
        }
    }
    
    func updateProfile(
        name: String?,
        username: String?,
        callNumber: String?,
        birthDate: String?,
        birthLocation: String?,
        gender: String?,
        profilePicture: Data?,
        completion: @escaping (Bool, String?) -> Void
    ) {
        DispatchQueue.main.async { self.isLoading = true }
        errorMessage = nil
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            completion(false, "No authentication token found")
            return
        }
        
        let url = "\(baseUrl)/user/edit-profile"
        var parameters: [String: Any] = [:]
        
        if let name = name { parameters["name"] = name }
        if let username = username { parameters["username"] = username }
        if let callNumber = callNumber { parameters["call_number"] = callNumber }
        
        if let birthDate = birthDate {
            let formattedDate = formatDateToYYYYMMDD(birthDate)
            parameters["birth_date"] = formattedDate
        }
        
        if let birthLocation = birthLocation { parameters["birth_location"] = birthLocation }
        if let gender = gender {
            parameters["gender"] = (gender == "Laki-laki") ? "male" : "female"
        }
        parameters["_method"] = "PUT"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                if let profilePicture = profilePicture, let compressedImage = self.compressImage(profilePicture) {
                    multipartFormData.append(compressedImage, withName: "profile_picture", fileName: "profile.jpg", mimeType: "image/jpeg")
                }
            }, to: url, method: .post, headers: headers)
            .responseData { response in
                DispatchQueue.main.async { self.isLoading = false }
                
                let statusCode = response.response?.statusCode ?? 0
                
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(Auth.self, from: data)
                        if (200..<300).contains(statusCode) {
                            DispatchQueue.main.async {
                                self.profile = result.data
                                self.getProfile()
                            }
                            completion(true, result.message)
                        } else {
                            DispatchQueue.main.async { self.errorMessage = result.message }
                            completion(false, result.message)
                        }
                    } catch {
                        completion(false, "Failed to parse response")
                    }
                case .failure:
                    completion(false, "An error occurred, please try again.")
                }
            }
        }
    }
    
    private func formatDateToYYYYMMDD(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func compressImage(_ imageData: Data, maxFileSize: Int = 2_000_000) -> Data? {
        guard let image = UIImage(data: imageData) else { return nil }
        
        var compression: CGFloat = 1.0
        var compressedData = image.jpegData(compressionQuality: compression)
        
        while let data = compressedData, data.count > maxFileSize, compression > 0.1 {
            compression -= 0.1
            compressedData = image.jpegData(compressionQuality: compression)
        }
        
        return compressedData
    }
}
