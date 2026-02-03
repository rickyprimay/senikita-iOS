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
    
    @ObservedObject var historyViewModel: HistoryViewModel
    
    init(historyViewModel: HistoryViewModel, historyItem: OrderHistory) {
        self.historyViewModel = historyViewModel
        self.historyItem = historyItem
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let firstProduct = historyItem.product?.first {
                headerSection
                
                Divider()
                    .background(Color(UIColor.systemGray5))
                
                productInfoSection(firstProduct)
                
                NavigationLink(destination: HistoryProductDetail(historyViewModel: historyViewModel, idHistory: historyItem.id)) {
                    HStack {
                        Text("Lihat Detail")
                            .font(AppFont.Nunito.footnoteSmall)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(Color("primary"))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(Color("primary").opacity(0.08))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var headerSection: some View {
        HStack {
            statusBadge
            
            Spacer()
            
            if let firstProduct = historyItem.product?.first {
                Text(firstProduct.created_at?.formattedDate() ?? "")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var statusBadge: some View {
        Group {
            if let statusInfo = currentStatusInfo {
                HStack(spacing: 4) {
                    Image(systemName: statusInfo.icon)
                        .font(.system(size: 10))
                    Text(statusInfo.text)
                        .font(.system(size: 11, weight: .semibold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusInfo.bgColor)
                .foregroundColor(statusInfo.textColor)
                .cornerRadius(8)
            }
        }
    }
    
    private var currentStatusInfo: (icon: String, text: String, bgColor: Color, textColor: Color)? {
        if historyItem.computedStatus == "pending",
           let createdDate = historyItem.created_at.toDate(),
           let daysPassed = Calendar.current.dateComponents([.day], from: createdDate, to: Date()).day,
           daysPassed > 2 {
            if let status = statusMap["gagal"] {
                return (status.icon, status.text, status.bgColor, status.textColor)
            } else {
                return nil
            }
        }
        if let status = statusMap[historyItem.computedStatus] {
            return (status.icon, status.text, status.bgColor, status.textColor)
        } else {
            return nil
        }
    }
    
    private func productInfoSection(_ product: ProductWithPivot) -> some View {
        HStack(spacing: 12) {
            if let imageUrl = URL(string: product.thumbnail ?? "") {
                WebImage(url: imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 70, height: 70)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.shop?.name ?? "")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(Color("primary"))
                
                Text(product.name ?? "Nama tidak tersedia")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(product.pivot?.qty ?? 0) item")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                
                Text(historyItem.price.formatPrice())
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}
