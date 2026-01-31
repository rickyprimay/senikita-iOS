//
//  ViewModelFactory.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import SwiftUI

@MainActor
final class ViewModelFactory {
    
    static let shared = ViewModelFactory()
    
    private let container: DIContainer
    
    init(container: DIContainer = .shared) {
        self.container = container
    }
    
    // MARK: - Auth
    
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel()
    }
    
    // MARK: - Home
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
    // MARK: - Product
    
    func makeProductViewModel() -> ProductViewModel {
        ProductViewModel()
    }
    
    // MARK: - Service
    
    func makeServiceViewModel() -> ServiceViewModel {
        ServiceViewModel()
    }
    
    // MARK: - Address
    
    func makeAddressViewModel() -> AddressViewModel {
        AddressViewModel()
    }
    
    // MARK: - Profile
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel()
    }
    
    // MARK: - Order
    
    func makeOrderViewModel() -> OrderViewModel {
        OrderViewModel()
    }
    
    // MARK: - ArtMap
    
    func makeArtMapViewModel() -> ArtMapViewModel {
        ArtMapViewModel()
    }
    
    // MARK: - Cart
    
    func makeCartViewModel() -> CartViewModel {
        CartViewModel()
    }
    
    // MARK: - History
    
    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel()
    }
    
    // MARK: - Payment
    
    func makePaymentViewModel() -> PaymentViewModel {
        PaymentViewModel()
    }
    
    // MARK: - PaymentService
    
    func makePaymentServiceViewModel() -> PaymentServiceViewModel {
        PaymentServiceViewModel()
    }
}

// MARK: - Environment Key

private struct ViewModelFactoryKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = ViewModelFactory()
}

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory {
        get { self[ViewModelFactoryKey.self] }
        set { self[ViewModelFactoryKey.self] = newValue }
    }
}

extension View {
    func withViewModelFactory(_ factory: ViewModelFactory) -> some View {
        environment(\.viewModelFactory, factory)
    }
}
