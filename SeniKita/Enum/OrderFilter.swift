//
//  OrderFilter.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import Foundation

func filterOrderByStatus(_ orders: [OrderHistory], status: String) -> [OrderHistory] {
    switch status {
    case "all":
        return orders
    case "pending":
        return orders.filter { $0.status == "pending" && $0.status_order == "waiting" }
    case "selesai":
        return orders.filter { $0.status == "DONE" && $0.status_order == "DONE" }
    case "diproses":
        return orders.filter { $0.status == "Success" && $0.status_order == "process" }
    case "dikirim":
        return orders.filter { $0.status == "Success" && $0.status_order == "delivered" }
    case "dibatalkan":
        return orders.filter { $0.status == "rejected" || $0.status_order == "rejected" }
    default:
        return orders
    }
}
