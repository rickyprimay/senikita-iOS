//
//  Extensions+Double.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import Foundation

extension Double {
    func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.locale = Locale(identifier: "id_ID")
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: self)) ?? "Rp 0"
    }
}
