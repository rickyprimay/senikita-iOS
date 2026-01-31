//
//  ServiceRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol ServiceRepositoryProtocol {
    func getServices() async throws -> [ServiceData]
    func getServiceDetail(id: Int) async throws -> ServiceData
}
