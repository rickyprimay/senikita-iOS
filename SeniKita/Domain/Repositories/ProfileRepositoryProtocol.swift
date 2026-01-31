//
//  ProfileRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> User
    func updateProfile(name: String, email: String, phone: String?) async throws -> User
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws -> String
}
