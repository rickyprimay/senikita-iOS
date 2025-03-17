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
        VStack(alignment: .leading, spacing: 8) {
            
            if let statusInfo = statusMap[historyItemService.computedStatus] {
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
            
            Text("Jasa Kesenian | \(historyItemService.no_transaction) | \(historyItemService.created_at.formattedDate())")
                .font(AppFont.Nunito.footnoteSmall)
                .foregroundColor(.gray)
            
            Divider()
            
            HStack{
                if let imageUrl = URL(string: historyItemService.service.thumbnail ?? "") {
                    WebImage(url: imageUrl)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                } else {
                    Color.gray.frame(width: 80, height: 80)
                }
                
                VStack(alignment: .leading){
                    Text(historyItemService.service.shop?.name ?? "")
                        .font(AppFont.Nunito.footnoteLarge)
                        .foregroundStyle(Color("tertiary"))
                    
                    Text(historyItemService.service.name ?? "Nama tidak tersedia")
                        .font(AppFont.Nunito.bodyLarge)
                    
                    Text("\(historyItemService.price.formatPrice())")
                        .font(AppFont.Nunito.bodyMedium)
                }
                
            }
            
            HStack {
                Spacer()
                
                NavigationLink(destination: HistoryServiceDetail(historyViewModel: historyViewModel, idHistory: historyItemService.id)) {
                    Text("Lihat Detail Transaksi >")
                        .font(AppFont.Nunito.footnoteLarge)
                        .bold()
                        .foregroundStyle(Color("primary"))
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
