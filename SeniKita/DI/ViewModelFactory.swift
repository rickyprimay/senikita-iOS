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
    
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel()
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
    func makeProductViewModel() -> ProductViewModel {
        ProductViewModel()
    }
    
    func makeServiceViewModel() -> ServiceViewModel {
        ServiceViewModel()
    }
    
    func makeAddressViewModel() -> AddressViewModel {
        AddressViewModel()
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel()
    }
    
    func makeOrderViewModel() -> OrderViewModel {
        OrderViewModel()
    }
    
    func makeArtMapViewModel() -> ArtMapViewModel {
        ArtMapViewModel()
    }
    
    func makeCartViewModel() -> CartViewModel {
        CartViewModel()
    }
    
    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel()
    }
    
    func makePaymentViewModel() -> PaymentViewModel {
        PaymentViewModel()
    }
    
    func makePaymentServiceViewModel() -> PaymentServiceViewModel {
        PaymentServiceViewModel()
    }
}


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
