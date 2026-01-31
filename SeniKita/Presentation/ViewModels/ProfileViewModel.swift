//
//  ProfileViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    
    private let profileRepository: ProfileRepositoryProtocol
    
    @Published var profile: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(profileRepository: ProfileRepositoryProtocol? = nil) {
        self.profileRepository = profileRepository ?? DIContainer.shared.profileRepository
        getProfile()
    }
    
    func getProfile() {
        guard DIContainer.shared.isAuthenticated else { return }
        isLoading = true
        
        Task {
            do {
                let user = try await profileRepository.getProfile()
                self.profile = user
                self.isLoading = false
            } catch {
                self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func updatePassword(oldPassword: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        isLoading = true
        errorMessage = nil
        
        guard DIContainer.shared.isAuthenticated else {
            isLoading = false
            completion(false, "No authentication token found")
            return
        }
        
        Task {
            do {
                _ = try await profileRepository.changePassword(
                    currentPassword: oldPassword,
                    newPassword: password,
                    confirmPassword: password
                )
                self.isLoading = false
                completion(true, "Password updated successfully")
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func updateProfile(
        name: String?,
        username: String?,
        callNumber: String?,
        birthDateString: String?,
        birthLocation: String?,
        gender: String?,
        profilePicture: Data?,
        completion: @escaping (Bool, String?) -> Void
    ) {
        isLoading = true
        errorMessage = nil
        
        guard DIContainer.shared.isAuthenticated else {
            isLoading = false
            completion(false, "No authentication token found")
            return
        }
        
        Task {
            do {
                _ = try await profileRepository.updateProfile(
                    name: name ?? "",
                    email: profile?.email ?? "",
                    phone: callNumber
                )
                
                self.getProfile()
                self.isLoading = false
                completion(true, "Profile updated successfully")
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                completion(false, error.localizedDescription)
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
        }
        return dateString
    }
}
