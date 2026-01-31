//
//  DIContainer.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

final class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    private lazy var _keychainManager: KeychainManagerProtocol = KeychainManager()
    private lazy var _sessionManager: SessionManagerProtocol = SessionManager(keychainManager: _keychainManager)
    private lazy var _userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()
    
    var keychainManager: KeychainManagerProtocol { _keychainManager }
    var sessionManager: SessionManagerProtocol { _sessionManager }
    var userDefaultsManager: UserDefaultsManagerProtocol { _userDefaultsManager }
    
    private lazy var _authRepository: AuthRepositoryProtocol = AuthRepository(sessionManager: _sessionManager)
    private lazy var _productRepository: ProductRepositoryProtocol = ProductRepository()
    private lazy var _serviceRepository: ServiceRepositoryProtocol = ServiceRepository()
    private lazy var _addressRepository: AddressRepositoryProtocol = AddressRepository()
    private lazy var _cartRepository: CartRepositoryProtocol = CartRepository()
    private lazy var _orderRepository: OrderRepositoryProtocol = OrderRepository()
    private lazy var _profileRepository: ProfileRepositoryProtocol = ProfileRepository()
    private lazy var _artMapRepository: ArtMapRepositoryProtocol = ArtMapRepository()
    private lazy var _aiRepository: AIRepositoryProtocol = AIRepository()
    
    var authRepository: AuthRepositoryProtocol { _authRepository }
    var productRepository: ProductRepositoryProtocol { _productRepository }
    var serviceRepository: ServiceRepositoryProtocol { _serviceRepository }
    var addressRepository: AddressRepositoryProtocol { _addressRepository }
    var cartRepository: CartRepositoryProtocol { _cartRepository }
    var orderRepository: OrderRepositoryProtocol { _orderRepository }
    var profileRepository: ProfileRepositoryProtocol { _profileRepository }
    var artMapRepository: ArtMapRepositoryProtocol { _artMapRepository }
    var aiRepository: AIRepositoryProtocol { _aiRepository }
    
    #if DEBUG
    func reset() {
        _keychainManager = KeychainManager()
        _sessionManager = SessionManager(keychainManager: _keychainManager)
        _userDefaultsManager = UserDefaultsManager()
    }
    #endif
}


extension DIContainer {
    var isAuthenticated: Bool {
        _sessionManager.isLoggedIn
    }
    
    var authToken: String? {
        _sessionManager.token
    }
    
    func clearSession() {
        _sessionManager.clearSession()
    }
}
