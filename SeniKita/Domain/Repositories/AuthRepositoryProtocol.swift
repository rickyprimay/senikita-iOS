//
//  AuthRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    func register(name: String, email: String, password: String) async throws -> String
    func verifyOTP(email: String, otp: String) async throws -> User
    func resendOTP(email: String) async throws -> String
    func verifyGoogle(idToken: String) async throws -> User
    func getProfile() async throws -> User
    func logout() async throws
}
