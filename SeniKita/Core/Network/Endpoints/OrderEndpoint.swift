//
//  OrderEndpoint.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import Alamofire

enum OrderEndpoint: Endpoint {
    case checkout(
        addressId: Int,
        shippingService: String,
        productIds: [Int],
        qtys: [Int]
    )
    case checkoutService(
        name: String,
        serviceId: Int,
        activityName: String,
        phone: String,
        activityDate: String,
        activityTime: String,
        provinceId: Int,
        cityId: Int,
        address: String,
        attendee: Int,
        description: String
    )
    case historyProduct
    case historyProductDetail(id: Int)
    case historyService
    case historyServiceDetail(id: Int)

    case checkOngkir(origin: Int, destination: Int, weight: Int, courier: String)
    case submitRating(transactionId: Int, productId: Int, rating: Int, review: String, images: [Data]?)
    case submitServiceRating(transactionId: Int, serviceId: Int, rating: Int, review: String, images: [Data]?)
    case history
    case historyDetail(id: Int)
    case serviceHistory
    case serviceHistoryDetail(id: Int)
    case cancelOrder(id: Int)
    case confirmOrder(id: Int)
    
    var path: String {
        switch self {
        case .checkout:
            return "user/order"
        case .checkoutService:
            return "user/order-service"
        case .historyProduct, .history:
            return "user/transaction-history"
        case .historyProductDetail(let id), .historyDetail(let id):
            return "user/transaction-history/\(id)"
        case .historyService, .serviceHistory:
            return "user/transaction-history-service"
        case .historyServiceDetail(let id), .serviceHistoryDetail(let id):
            return "user/transaction-history-service/\(id)"
        case .cancelOrder(let id):
            return "user/order/\(id)/cancel"
        case .confirmOrder(let id):
            return "user/order/\(id)/confirm"
        case .checkOngkir:
            return "check-ongkir"
        case .submitRating:
            return "user/product/rating"
        case .submitServiceRating:
            return "user/service/rating"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .checkout, .checkoutService, .checkOngkir, .cancelOrder, .confirmOrder, .submitRating, .submitServiceRating:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .checkout(let addressId, let shippingService, let productIds, let qtys):
            return [
                "address_id": addressId,
                "service": shippingService,
                "product_ids": productIds,
                "qtys": qtys,
                "courier": "jne"
            ]
        case .checkoutService(let name, let serviceId, let activityName, let phone, let activityDate, let activityTime, let provinceId, let cityId, let address, let attendee, let description):
            return [
                "name": name,
                "service_id": serviceId,
                "activity_name": activityName,
                "phone": phone,
                "qty": 1,
                "activity_date": activityDate,
                "activity_time": activityTime,
                "province_id": provinceId,
                "city_id": cityId,
                "address": address,
                "attendee": attendee,
                "description": description
            ]
        case .checkOngkir(let origin, let destination, let weight, let courier):
            return [
                "origin": origin,
                "destination": destination,
                "weight": weight,
                "courier": courier
            ]
        default:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .checkOngkir:
            return false
        default:
            return true
        }
    }
    
    var multipartFormData: ((MultipartFormData) -> Void)? {
        switch self {
        case .submitRating(let transactionId, let productId, let rating, let review, let images):
            return { multipartFormData in
                multipartFormData.append("\(transactionId)".data(using: .utf8)!, withName: "transaction_id")
                multipartFormData.append("\(productId)".data(using: .utf8)!, withName: "product_id")
                multipartFormData.append("\(rating)".data(using: .utf8)!, withName: "rating")
                multipartFormData.append(review.data(using: .utf8)!, withName: "review")
                
                if let images = images {
                    for (index, imageData) in images.enumerated() {
                        multipartFormData.append(imageData, withName: "images[]", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                    }
                }
            }
        case .submitServiceRating(let transactionId, let serviceId, let rating, let review, let images):
            return { multipartFormData in
                multipartFormData.append("\(transactionId)".data(using: .utf8)!, withName: "transaction_service_id")
                multipartFormData.append("\(serviceId)".data(using: .utf8)!, withName: "service_id")
                multipartFormData.append("\(rating)".data(using: .utf8)!, withName: "rating")
                multipartFormData.append(review.data(using: .utf8)!, withName: "review")
                
                if let images = images {
                    for (index, imageData) in images.enumerated() {
                        multipartFormData.append(imageData, withName: "images[]", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                    }
                }
            }
        default:
            return nil
        }
    }
}
