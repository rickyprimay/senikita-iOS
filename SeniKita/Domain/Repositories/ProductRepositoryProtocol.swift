//
//  ProductRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol ProductRepositoryProtocol {
    func getProducts() async throws -> [ProductData]
    func getProductDetail(id: Int) async throws -> ProductData
    func getProductsByCategory(categoryId: Int) async throws -> [ProductData]
    func searchProducts(query: String) async throws -> [ProductData]
}
