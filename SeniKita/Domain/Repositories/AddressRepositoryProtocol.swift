//
//  AddressRepositoryProtocol.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

protocol AddressRepositoryProtocol {
    func getAddresses() async throws -> [Address]
    func getAddressDetail(id: Int) async throws -> Address
    func createAddress(
        name: String,
        phone: String,
        provinceId: Int,
        cityId: Int,
        address: String,
        postalCode: String,
        note: String?,
        isDefault: Bool
    ) async throws -> Address
    func updateAddress(
        id: Int,
        name: String,
        phone: String,
        provinceId: Int,
        cityId: Int,
        address: String,
        postalCode: String,
        note: String?,
        isDefault: Bool
    ) async throws -> Address
    func deleteAddress(id: Int) async throws
    func getCities() async throws -> [City]
    func getProvinces() async throws -> [Province]
    func getCitiesByProvince(provinceId: Int) async throws -> [City]
}
