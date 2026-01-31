//
//  SessionManager.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol SessionManagerProtocol {
    var isLoggedIn: Bool { get }
    var token: String? { get }
    var authToken: String? { get }
    
    func saveToken(_ token: String)
    func clearSession()
    func migrateFromUserDefaults()
}

private enum SessionKeys {
    static let authToken = "authToken"
    static let userID = "userID"
    static let userName = "userName"
    static let userEmail = "userEmail"
}

final class SessionManager: SessionManagerProtocol {
    
    static let shared = SessionManager()
    
    private let keychainManager: KeychainManagerProtocol
    private let userDefaults: UserDefaults
    
    private var hasMigrated: Bool {
        get { userDefaults.bool(forKey: "hasSecureTokenMigration") }
        set { userDefaults.set(newValue, forKey: "hasSecureTokenMigration") }
    }
    
    init(
        keychainManager: KeychainManagerProtocol = KeychainManager.shared,
        userDefaults: UserDefaults = .standard
    ) {
        self.keychainManager = keychainManager
        self.userDefaults = userDefaults
    }
    
    var isLoggedIn: Bool {
        return token != nil && !token!.isEmpty
    }
    
    var token: String? {
        if let token = try? keychainManager.loadString(for: SessionKeys.authToken), !token.isEmpty {
            return token
        }
        if let token = userDefaults.string(forKey: SessionKeys.authToken), !token.isEmpty {
            return token
        }
        
        return nil
    }
    
    /// Alias for token - backward compatibility
    var authToken: String? {
        return token
    }
    
    func saveToken(_ token: String) {
        do {
            try keychainManager.save(token, for: SessionKeys.authToken)
        } catch {
            print("⚠️ Failed to save token to Keychain: \(error)")
        }
        userDefaults.set(token, forKey: SessionKeys.authToken)
    }
    
    func clearSession() {
        do {
            try keychainManager.delete(for: SessionKeys.authToken)
        } catch {
            print("⚠️ Failed to delete token from Keychain: \(error)")
        }
        userDefaults.removeObject(forKey: SessionKeys.authToken)
        userDefaults.removeObject(forKey: SessionKeys.userID)
        userDefaults.removeObject(forKey: SessionKeys.userName)
        userDefaults.removeObject(forKey: SessionKeys.userEmail)
    }
    
    func migrateFromUserDefaults() {
        guard !hasMigrated else { return }
        if let existingToken = userDefaults.string(forKey: SessionKeys.authToken), !existingToken.isEmpty {
            do {
                try keychainManager.save(existingToken, for: SessionKeys.authToken)
                hasMigrated = true
            } catch {
                print("⚠️ Token migration to Keychain failed: \(error.localizedDescription)")
            }
        } else {
            hasMigrated = true
        }
    }
}
