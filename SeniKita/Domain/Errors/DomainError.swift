//
//  DomainError.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation

enum DomainError: LocalizedError {
    case validationFailed(String)
    case businessRuleViolation(String)
    case entityNotFound(String)
    case unauthorized
    case permissionDenied
    case dataCorrupted
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .validationFailed(let message):
            return message
        case .businessRuleViolation(let message):
            return message
        case .entityNotFound(let entity):
            return "\(entity) tidak ditemukan"
        case .unauthorized:
            return "Sesi Anda telah berakhir. Silakan login kembali"
        case .permissionDenied:
            return "Anda tidak memiliki akses untuk melakukan tindakan ini"
        case .dataCorrupted:
            return "Data tidak valid"
        case .unknown(let message):
            return message
        }
    }
    
    var failureReason: String? {
        switch self {
        case .validationFailed:
            return "Validasi gagal"
        case .businessRuleViolation:
            return "Aturan bisnis dilanggar"
        case .entityNotFound:
            return "Data tidak ditemukan"
        case .unauthorized:
            return "Tidak terautentikasi"
        case .permissionDenied:
            return "Akses ditolak"
        case .dataCorrupted:
            return "Data rusak"
        case .unknown:
            return "Kesalahan tidak diketahui"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .validationFailed:
            return "Periksa kembali data yang Anda masukkan"
        case .businessRuleViolation:
            return "Pastikan data memenuhi persyaratan"
        case .entityNotFound:
            return "Coba refresh atau periksa koneksi internet"
        case .unauthorized:
            return "Silakan login kembali"
        case .permissionDenied:
            return "Hubungi administrator untuk bantuan"
        case .dataCorrupted:
            return "Coba logout dan login kembali"
        case .unknown:
            return "Coba lagi atau hubungi customer support"
        }
    }
}
