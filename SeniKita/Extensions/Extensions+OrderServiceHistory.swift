//
//  Extensions+OrderServiceHistory.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

extension OrderServiceHistory {
    var computedStatus: String {
        switch (status.lowercased(), status_order.lowercased()) {
        case ("done", "done"):
            return "selesai"
        case ("success", "process"):
            return "diproses"
        case ("success", "delivered"):
            return "dikirim"
        case ("rejected", _), (_, "rejected"):
            return "dibatalkan"
        case ("pending", _), (_, "pending"), ("pending", "waiting"):
            return "pending"
        default:
            return "unknown"
        }
    }
}
