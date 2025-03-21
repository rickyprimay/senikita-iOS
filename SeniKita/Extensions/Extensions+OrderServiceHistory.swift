//
//  Extensions+OrderServiceHistory.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

extension OrderServiceHistory {
    var computedStatus: String {
        switch (status, status_order) {
        case ("DONE", "DONE"):
            return "selesai"
        case ("Success", "process"):
            return "diproses"
        case ("Success", "delivered"):
            return "dikirim"
        case ("rejected", _), (_, "rejected"):
            return "dibatalkan"
        case ("pending", "waiting"):
            return "pending"
        default:
            return "unknown"
        }
    }
}
