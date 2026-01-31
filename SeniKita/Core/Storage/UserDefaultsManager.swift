//
//  UserDefaultsManager.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol UserDefaultsManagerProtocol {
    func set<T: Codable>(_ value: T, forKey key: String)
    func get<T: Codable>(forKey key: String) -> T?
    func setString(_ value: String, forKey key: String)
    func getString(forKey key: String) -> String?
    func setBool(_ value: Bool, forKey key: String)
    func getBool(forKey key: String) -> Bool
    func setInt(_ value: Int, forKey key: String)
    func getInt(forKey key: String) -> Int
    func remove(forKey key: String)
    func clearAll()
}

enum UserDefaultsKeys {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let userID = "userID"
    static let userName = "userName"
    static let userEmail = "userEmail"
    static let hasSecureTokenMigration = "hasSecureTokenMigration"
    static let lastSelectedCity = "lastSelectedCity"
    static let lastSelectedProvince = "lastSelectedProvince"
}

final class UserDefaultsManager: UserDefaultsManagerProtocol {
    
    static let shared = UserDefaultsManager()
    
    private let defaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? encoder.encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    func get<T: Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func setString(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getString(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }
    
    func setBool(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getBool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }
    
    func setInt(_ value: Int, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getInt(forKey key: String) -> Int {
        defaults.integer(forKey: key)
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier ?? ""
        defaults.removePersistentDomain(forName: domain)
    }
}
