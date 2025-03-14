//
//  HistoryCardProduct.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryCardProduct: View {
    let historyItem: OrderHistory
    
    func formattedDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "NaN" }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "id_ID")
            outputFormatter.dateFormat = "d MMMM yyyy"
            return outputFormatter.string(from: date)
        } else {
            return "NaN"
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: price)) ?? "0"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let firstProduct = historyItem.product.first {
                
                if let statusInfo = statusMap[historyItem.computedStatus] {
                    HStack {
                        Image(systemName: statusInfo.icon)
                        Text(statusInfo.text)
                    }
                    .font(AppFont.Nunito.footnoteSmall)
                    .bold()
                    .padding(8)
                    .background(statusInfo.bgColor)
                    .foregroundColor(statusInfo.textColor)
                    .cornerRadius(10)
                }
                
                Divider()
                
                Text("Produk Kesenian | \(historyItem.no_transaction) | \(formattedDate(firstProduct.created_at))")
                    .font(AppFont.Nunito.footnoteSmall)
                    .foregroundColor(.gray)
                
                Divider()
                
                HStack{
                    if let imageUrl = URL(string: firstProduct.thumbnail ?? "") {
                        WebImage(url: imageUrl)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    } else {
                        Color.gray.frame(width: 80, height: 80)
                    }
                    
                    VStack(alignment: .leading){
                        Text(firstProduct.shop?.name ?? "")
                            .font(AppFont.Nunito.footnoteLarge)
                            .foregroundStyle(Color("tertiary"))
                        
                        Text(firstProduct.name ?? "Nama tidak tersedia")
                            .font(AppFont.Nunito.bodyMedium)
                        
                        Text("\(firstProduct.pivot?.qty ?? 0) item x \(formatPrice(Double(firstProduct.price ?? 0)))")
                            .font(AppFont.Nunito.footnoteSmall)
                        
                        Text("\(formatPrice(historyItem.price))")
                            .font(AppFont.Nunito.bodyMedium)
                    }
                    
                }
                
                HStack {
                    Spacer()
                    
                    Button{
                        
                    } label: {
                        Text("Lihat Detail Transaksi >")
                            .font(AppFont.Nunito.footnoteLarge)
                            .bold()
                            .foregroundStyle(Color("primary"))
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}
