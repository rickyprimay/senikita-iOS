//
//  AddressEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum AddressEndpoint: Endpoint {
    case list
    case detail(id: Int)
    case create(
        labelAddress: String,
        name: String,
        phone: String,
        provinceId: Int,
        cityId: Int,
        addressDetail: String,
        postalCode: String,
        note: String?,
        isDefault: Bool
    )
    case update(
        id: Int,
        labelAddress: String,
        name: String,
        phone: String,
        provinceId: Int,
        cityId: Int,
        addressDetail: String,
        postalCode: String,
        note: String?,
        isDefault: Bool
    )
    case delete(id: Int)
    case cities
    case provinces
    case citiesByProvince(provinceId: Int)
    
    var path: String {
        switch self {
        case .list, .create:
            return "user/address"
        case .detail(let id), .update(let id, _, _, _, _, _, _, _, _, _), .delete(let id):
            return "user/address/\(id)"
        case .cities:
            return "cities"
        case .provinces:
            return "provinces"
        case .citiesByProvince(let provinceId):
            return "cities-by-province/\(provinceId)"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .list, .detail, .cities, .provinces, .citiesByProvince:
            return .get
        case .create:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .create(let labelAddress, let name, let phone, let provinceId, let cityId, let addressDetail, let postalCode, let note, let isDefault):
            return [
                "label_address": labelAddress,
                "name": name,
                "phone": phone,
                "province_id": provinceId,
                "city_id": cityId,
                "address_detail": addressDetail,
                "postal_code": postalCode,
                "note": note ?? "",
                "is_default": isDefault
            ]
        case .update(_, let labelAddress, let name, let phone, let provinceId, let cityId, let addressDetail, let postalCode, let note, let isDefault):
            return [
                "label_address": labelAddress,
                "name": name,
                "phone": phone,
                "province_id": provinceId,
                "city_id": cityId,
                "address_detail": addressDetail,
                "postal_code": postalCode,
                "note": note ?? "",
                "is_default": isDefault
            ]
        default:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .cities, .provinces, .citiesByProvince:
            return false
        default:
            return true
        }
    }
}
