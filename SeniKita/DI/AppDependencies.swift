//
//  AppDependencies.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import SwiftUI

@propertyWrapper
struct Injected<T> {
    private let keyPath: KeyPath<DIContainer, T>
    
    init(_ keyPath: KeyPath<DIContainer, T>) {
        self.keyPath = keyPath
    }
    
    var wrappedValue: T {
        DIContainer.shared[keyPath: keyPath]
    }
}

@propertyWrapper
struct LazyInjected<T> {
    private let factory: () -> T
    private var instance: T?
    
    init(_ factory: @escaping () -> T) {
        self.factory = factory
    }
    
    var wrappedValue: T {
        mutating get {
            if instance == nil {
                instance = factory()
            }
            return instance!
        }
    }
}


struct AuthRepositoryProvider {
    let repository: AuthRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.authRepository
    }
}

struct ProductRepositoryProvider {
    let repository: ProductRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.productRepository
    }
}

struct ServiceRepositoryProvider {
    let repository: ServiceRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.serviceRepository
    }
}

struct AddressRepositoryProvider {
    let repository: AddressRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.addressRepository
    }
}

struct CartRepositoryProvider {
    let repository: CartRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.cartRepository
    }
}

struct OrderRepositoryProvider {
    let repository: OrderRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.orderRepository
    }
}

struct ProfileRepositoryProvider {
    let repository: ProfileRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.repository = container.profileRepository
    }
}

struct ArtMapRepositoryProvider {
    let artMapRepository: ArtMapRepositoryProtocol
    let aiRepository: AIRepositoryProtocol
    
    init(container: DIContainer = .shared) {
        self.artMapRepository = container.artMapRepository
        self.aiRepository = container.aiRepository
    }
}
