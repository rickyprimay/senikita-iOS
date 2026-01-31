//
//  NetworkError.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badRequest(String?)
    case unauthorized
    case forbidden
    case notFound
    case validationError(message: String)
    case serverError(_ message: String)
    case serverErrorCode(statusCode: Int)
    case decodingError(Error)
    case decodingFailed
    case encodingError
    case noInternetConnection
    case timeout
    case unknown(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL tidak valid"
        case .invalidResponse:
            return "Respons tidak valid dari server"
        case .badRequest(let message):
            return message ?? "Permintaan tidak valid"
        case .unauthorized:
            return "Sesi Anda telah berakhir. Silakan login kembali"
        case .forbidden:
            return "Anda tidak memiliki akses ke resource ini"
        case .notFound:
            return "Data tidak ditemukan"
        case .validationError(let message):
            return message
        case .serverError(let message):
            return message
        case .serverErrorCode(let statusCode):
            return "Terjadi kesalahan server (Error \(statusCode))"
        case .decodingError:
            return "Gagal memproses data dari server"
        case .decodingFailed:
            return "Gagal memproses data dari server"
        case .encodingError:
            return "Gagal memproses permintaan"
        case .noInternetConnection:
            return "Tidak ada koneksi internet"
        case .timeout:
            return "Koneksi timeout. Silakan coba lagi"
        case .unknown(let statusCode):
            return "Terjadi kesalahan (Error \(statusCode))"
        }
    }
    
    var isAuthError: Bool {
        switch self {
        case .unauthorized, .forbidden:
            return true
        default:
            return false
        }
    }
}
