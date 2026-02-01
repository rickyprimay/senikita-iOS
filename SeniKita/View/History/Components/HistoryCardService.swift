//
//  HistoryCardService.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryCardService: View {
    
    let historyItemService: OrderServiceHistory
    
    @ObservedObject var historyViewModel: HistoryViewModel
    
    init(historyViewModel: HistoryViewModel, historyItemService: OrderServiceHistory) {
        self.historyViewModel = historyViewModel
        self.historyItemService = historyItemService
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            
            Divider()
                .background(Color(UIColor.systemGray5))
            
            serviceInfoSection
            
            NavigationLink(destination: HistoryServiceDetail(historyViewModel: historyViewModel, idHistory: historyItemService.id)) {
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
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private var headerSection: some View {
        HStack {
            statusBadge
            
            Spacer()
            
            Text(historyItemService.created_at.formattedDate())
                .font(AppFont.Raleway.footnoteSmall)
                .foregroundColor(.secondary)
        }
    }
    
    private var statusBadge: some View {
        Group {
            if let statusInfo = statusMap[historyItemService.computedStatus] {
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
    
    private var serviceInfoSection: some View {
        HStack(spacing: 12) {
            if let imageUrl = URL(string: historyItemService.service?.thumbnail ?? "") {
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
                Text(historyItemService.service?.shop?.name ?? "")
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(Color("primary"))
                
                Text(historyItemService.service?.name ?? "Nama tidak tersedia")
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(historyItemService.price.formatPrice())
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}
