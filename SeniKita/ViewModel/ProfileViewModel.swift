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
        isLoading = true
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            print("No auth token found")
            isLoading = false
            return
        }
        
        let url = "\(baseUrl)/auth/profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                Task { @MainActor in self?.isLoading = false }
                switch response.result {
                case .success(let data):
                    do {
                        let profileResponse = try JSONDecoder().decode(Auth.self, from: data)
                        
                        Task { @MainActor in
                            self?.profile = profileResponse.data
                        }
                        
                    } catch {
                        print("JSON decoding failed: \(error)")
                    }
                    
                case .failure(let error):
                    print("Request failed: \(error.localizedDescription)")
                }
            }
    }
    
    func updatePassword(oldPassword: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Task { @MainActor in self.isLoading = true }
        errorMessage = nil
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            print("No auth token found")
            Task { @MainActor in self.isLoading = false }
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
        
        print("📤 Sending password update request to: \(url)")
        print("📦 Request parameters: \(parameters)")
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: PasswordUpdateResponse.self) { response in
                Task { @MainActor in self.isLoading = false }
                
                let statusCode = response.response?.statusCode ?? 0
                
                switch response.result {
                case .success(let result):
                    if (200..<300).contains(statusCode) {
                        print("✅ Password update successful: \(result.message)")
                        completion(true, result.message)
                    } else {
                        print("❌ Password update failed: \(result.message) | Status: \(statusCode)")
                        Task { @MainActor in self.errorMessage = result.message }
                        completion(false, result.message)
                    }
                case .failure(let error):
                    if let data = response.data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = jsonObject["message"] as? String {
                        print("🚨 Password update request failed: \(error.localizedDescription)")
                        print("📜 Server response: \(jsonObject)")
                        Task { @MainActor in self.errorMessage = message }
                        completion(false, message)
                    } else {
                        print("🚨 Password update request failed: \(error.localizedDescription)")
                        Task { @MainActor in self.errorMessage = "An error occurred, please try again." }
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
        Task { @MainActor in self.isLoading = true }
        errorMessage = nil
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            print("🚨 No auth token found")
            Task { @MainActor in self.isLoading = false }
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
            print("📆 Birth date formatted: \(formattedDate)")
        }
        
        if let birthLocation = birthLocation { parameters["birth_location"] = birthLocation }
        if let gender = gender {
            let genderValue = (gender == "Laki-laki") ? "male" : "female"
            parameters["gender"] = genderValue
        }
        parameters["_method"] = "PUT"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        print("📤 Sending profile update request to: \(url)")
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            if let profilePicture = profilePicture, let compressedImage = self.compressImage(profilePicture) {
                multipartFormData.append(compressedImage, withName: "profile_picture", fileName: "profile.jpg", mimeType: "image/jpeg")
                print("🖼️ Profile picture compressed to \(compressedImage.count / 1024) KB")
            } else {
                print("⚠️ No valid profile picture provided or compression failed")
            }
        }, to: url, method: .post, headers: headers)
        .responseData { response in
            Task { @MainActor in self.isLoading = false }
            
            let statusCode = response.response?.statusCode ?? 0
            
            print("📡 Response received - Status Code: \(statusCode)")
            
            switch response.result {
            case .success(let data):
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("📜 Full Server Response: \(jsonObject)")
                }
                
                do {
                    let result = try JSONDecoder().decode(Auth.self, from: data)
                    if (200..<300).contains(statusCode) {
                        print("✅ Profile update successful: \(result.message)")
                        Task { @MainActor in
                            self.profile = result.data
                            self.getProfile()
                        }
                        completion(true, result.message)
                    } else {
                        print("❌ Profile update failed: \(result.message) | Status: \(statusCode)")
                        Task { @MainActor in self.errorMessage = result.message }
                        completion(false, result.message)
                    }
                } catch {
                    print("🚨 JSON Decoding Error: \(error)")
                    completion(false, "Failed to parse response")
                }
                
            case .failure(let error):
                if let data = response.data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("🚨 Request failed: \(error.localizedDescription)")
                    print("📜 Server response: \(jsonObject)")
                    let message = jsonObject["message"] as? String ?? "Unknown error"
                    Task { @MainActor in self.errorMessage = message }
                    completion(false, message)
                } else {
                    print("🚨 Request failed: \(error.localizedDescription)")
                    Task { @MainActor in self.errorMessage = "An error occurred, please try again." }
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
            print("⚠️ Invalid date format: \(dateString)")
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
