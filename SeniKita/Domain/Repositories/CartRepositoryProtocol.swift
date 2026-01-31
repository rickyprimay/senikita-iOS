//
//  CartRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol CartRepositoryProtocol {
    func getCart() async throws -> [Cart]
    func getCartItems() async throws -> [Cart]
    func addToCart(productId: Int, quantity: Int) async throws
    func incrementItem(cartItemId: Int) async throws
    func decrementItem(cartItemId: Int) async throws
    func removeItem(cartItemId: Int) async throws
}
