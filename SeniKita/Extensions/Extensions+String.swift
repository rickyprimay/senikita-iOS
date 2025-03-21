//
//  Extensions+String.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import Foundation

extension String {
    func formattedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "id_ID")
            outputFormatter.dateFormat = "d MMMM yyyy"
            return outputFormatter.string(from: date)
        } else {
            return "NaN"
        }
    }
    
    func formattedDateWithTime() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "id_ID")
            outputFormatter.dateFormat = "d MMMM yyyy HH:mm"
            return outputFormatter.string(from: date)
        } else {
            return "NaN"
        }
    }
    
    var stripHTML: String {
        let withoutHTML = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        let withoutNbsp = withoutHTML.replacingOccurrences(of: "&nbsp;", with: " ")
        return withoutNbsp
    }
    
}
