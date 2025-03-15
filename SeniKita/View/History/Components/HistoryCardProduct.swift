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
                
                Text("Produk Kesenian | \(historyItem.no_transaction) | \(firstProduct.created_at?.formattedDate() ?? "")")
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
                        
                        Text("\(firstProduct.pivot?.qty ?? 0) item x \((firstProduct.price ?? 0).toDouble().formatPrice())")
                            .font(AppFont.Nunito.footnoteSmall)
                        
                        Text("\(historyItem.price.formatPrice())")
                            .font(AppFont.Nunito.bodyMedium)
                    }
                    
                }
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: HistoryProductDetail(historyViewModel: historyViewModel, idHistory: historyItem.id)){
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
