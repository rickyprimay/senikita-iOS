//
//  HistoryProductDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 14/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryProductDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var historyViewModel: HistoryViewModel
    
    var idHistory: Int
    
    init(historyViewModel: HistoryViewModel, idHistory: Int) {
        self.historyViewModel = historyViewModel
        self.idHistory = idHistory
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if let historyDetail = historyViewModel.historyProductDetail {
                            statusCard(historyDetail: historyDetail)
                            productCard(historyDetail: historyDetail)
                            shippingInfoCard(historyDetail: historyDetail)
                            paymentDetailsCard(historyDetail: historyDetail)
                            if historyDetail.computedStatus == "pending",
                               let createdDate = historyDetail.created_at.toDate(),
                               let daysPassed = Calendar.current.dateComponents([.day], from: createdDate, to: Date()).day,
                               daysPassed <= 2 {
                                paymentButton(historyDetail: historyDetail)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            
            if historyViewModel.isLoading {
                Loading(opacity: 0.5)
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            historyViewModel.getDetailHistoryProduct(idHistory: idHistory)
        }
        .hideTabBar()
    }
    
    private var navigationHeader: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("primary"))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            }
            
            Spacer()
            
            Text("Detail Transaksi")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func statusCard(historyDetail: OrderHistory) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Status Pesanan")
                    .font(AppFont.Raleway.bodyLarge)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let statusInfo = getStatusInfo(for: historyDetail) {
                    HStack(spacing: 6) {
                        Image(systemName: statusInfo.icon)
                            .font(.system(size: 10))
                        Text(statusInfo.text)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusInfo.bgColor)
                    .foregroundColor(statusInfo.textColor)
                    .cornerRadius(8)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("No. Invoice")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    Text(historyDetail.no_transaction)
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Tanggal Pembelian")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    Text(historyDetail.created_at.formattedDateWithTime())
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func productCard(historyDetail: OrderHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Produk")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            if let product = historyDetail.product?.first {
                HStack(spacing: 16) {
                    if let imageUrl = URL(string: product.thumbnail ?? "") {
                        WebImage(url: imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 80, height: 80)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name ?? "Nama tidak tersedia")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        Text("\(product.pivot?.qty ?? 0) item x \((product.price ?? 0).toDouble().formatPrice())")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                        
                        Text(historyDetail.price.formatPrice())
                            .font(AppFont.Nunito.bodyLarge)
                            .foregroundColor(Color("primary"))
                    }
                }
                
                if let note = historyDetail.note, !note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Catatan")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                        
                        Text(note)
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.primary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func shippingInfoCard(historyDetail: OrderHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Info Pengiriman")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                detailRow(label: "Kurir", value: "\(historyDetail.courier.uppercased()) - \(historyDetail.service)")
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Alamat Pengiriman")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(historyDetail.address?.name ?? "")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.primary)
                        
                        Text(historyDetail.address?.phone ?? "")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                        
                        Text(historyDetail.address?.address_detail ?? "")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        Text("\(historyDetail.address?.city?.name ?? ""), \(historyDetail.address?.province?.name ?? "")")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func paymentDetailsCard(historyDetail: OrderHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rincian Pembayaran")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                paymentRow(label: "Total Harga", value: historyDetail.price.formatPrice())
                paymentRow(label: "Total Ongkos Kirim", value: historyDetail.ongkir.formatPrice())
                paymentRow(label: "Biaya Layanan", value: "Rp 5.000")
                
                Divider()
                
                HStack {
                    Text("Total Pembayaran")
                        .font(AppFont.Nunito.bodyLarge)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(historyDetail.total_price.formatPrice())
                        .font(AppFont.Nunito.headerMedium)
                        .foregroundColor(Color("primary"))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func paymentButton(historyDetail: OrderHistory) -> some View {
        Button(action: {
            if let url = URL(string: historyDetail.invoice_url) {
                UIApplication.shared.open(url)
            }
        }) {
            Text("Bayar Sekarang")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("primary"))
                .cornerRadius(12)
                .shadow(color: Color("primary").opacity(0.3), radius: 8, y: 4)
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(AppFont.Nunito.bodyMedium)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    private func paymentRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(AppFont.Raleway.bodyMedium)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(AppFont.Nunito.bodyMedium)
                .foregroundColor(.primary)
        }
    }
    
    private func getStatusInfo(for detail: OrderHistory) -> (icon: String, text: String, bgColor: Color, textColor: Color)? {
        if detail.computedStatus == "pending",
           let createdDate = detail.created_at.toDate(),
           let daysPassed = Calendar.current.dateComponents([.day], from: createdDate, to: Date()).day,
           daysPassed > 2 {
            
            if let status = statusMap["gagal"] {
                 return (status.icon, status.text, status.bgColor, status.textColor)
            }
            return nil
        }
        
        if let status = statusMap[detail.computedStatus] {
            return (status.icon, status.text, status.bgColor, status.textColor)
        }
        return nil
    }
}
