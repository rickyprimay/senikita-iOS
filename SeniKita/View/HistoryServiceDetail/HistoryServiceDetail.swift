//
//  HistoryServiceDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryServiceDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var historyViewModel: HistoryViewModel
    
    var idHistory: Int
    
    @State private var showCompletionAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
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
                        if let historyDetail = historyViewModel.historyServiceDetail {
                            statusCard(historyDetail: historyDetail)
                            serviceCard(historyDetail: historyDetail)
                            eventInfoCard(historyDetail: historyDetail)
                            contactInfoCard(historyDetail: historyDetail)
                            paymentDetailsCard(historyDetail: historyDetail)
                            if historyDetail.computedStatus == "pending" {
                                paymentButton(historyDetail: historyDetail)
                            }
                            
                            if historyDetail.status_order.lowercased() == "success" || historyDetail.status_order.lowercased() == "confirmed" {
                                serviceCompletionButton(historyDetail: historyDetail)
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
            historyViewModel.getDetailHistoryService(idHistory: idHistory)
        }
        .alert(isPresented: $showCompletionAlert) {
            Alert(
                title: Text(isSuccess ? "Berhasil" : "Gagal"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
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
    
    private func statusCard(historyDetail: OrderServiceHistory) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Status Pesanan")
                    .font(AppFont.Raleway.bodyLarge)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let statusInfo = statusMap[historyDetail.computedStatus] {
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
    
    private func serviceCard(historyDetail: OrderServiceHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Jasa Kesenian")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                if let imageUrl = URL(string: historyDetail.service?.thumbnail ?? "") {
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
                    Text(historyDetail.service?.shop?.name ?? "")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(Color("primary"))
                    
                    Text(historyDetail.service?.name ?? "Nama tidak tersedia")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(historyDetail.price.formatPrice())
                        .font(AppFont.Nunito.bodyLarge)
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
    
    private func eventInfoCard(historyDetail: OrderServiceHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detail Acara")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                detailRow(label: "Nama Acara", value: historyDetail.activity_name)
                detailRow(label: "Tanggal", value: historyDetail.activity_date)
                detailRow(label: "Waktu", value: historyDetail.activity_time)
                detailRow(label: "Lokasi", value: historyDetail.address)
                detailRow(label: "Peserta", value: "\(historyDetail.attendee) Orang")
                
                if let description = historyDetail.description, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Catatan")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                        
                        Text(description)
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
    
    private func contactInfoCard(historyDetail: OrderServiceHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Info Penanggung Jawab")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                detailRow(label: "Nama", value: historyDetail.name)
                detailRow(label: "Telepon", value: historyDetail.phone)
                detailRow(label: "Alamat", value: historyDetail.address)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    private func paymentDetailsCard(historyDetail: OrderServiceHistory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rincian Pembayaran")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                paymentRow(label: "Total Harga", value: historyDetail.price.formatPrice())
                paymentRow(label: "Biaya Layanan", value: "Rp 5.000")
                
                Divider()
                
                HStack {
                    Text("Total Pembayaran")
                        .font(AppFont.Nunito.bodyLarge)
                        .foregroundColor(.primary)
                    Spacer()
                    Text((historyDetail.price + 5000).formatPrice())
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
    
    private func paymentButton(historyDetail: OrderServiceHistory) -> some View {
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
    
    private func serviceCompletionButton(historyDetail: OrderServiceHistory) -> some View {
        Button(action: {
            historyViewModel.confirmServiceReceived(orderId: historyDetail.id) { success, message in
                isSuccess = success
                alertMessage = message
                showCompletionAlert = true
            }
        }) {
            Text("Jasa Selesai")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.green)
                .cornerRadius(12)
                .shadow(color: Color.green.opacity(0.3), radius: 8, y: 4)
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
