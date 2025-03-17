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
    
    init(historyViewModel: HistoryViewModel, idHistory: Int) {
        self.historyViewModel = historyViewModel
        self.idHistory = idHistory
    }
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView{
                    VStack(alignment: .leading){
                        
                        if let statusInfo = statusMap[historyViewModel.historyServiceDetail?.computedStatus ?? "selesai"] {
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
                        
                        HStack {
                            Text("No. Invoice")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.light)
                            Spacer()
                            Text(historyViewModel.historyServiceDetail?.no_transaction ?? "")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Tanggal Pembelian")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.light)
                            Spacer()
                            Text(historyViewModel.historyServiceDetail?.created_at.formattedDateWithTime() ?? "")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.bold)
                        }
                        
                        HStack(spacing: 12) {
                            if let imageUrl = URL(string: historyViewModel.historyServiceDetail?.service.thumbnail ?? "") {
                                WebImage(url: imageUrl)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } else {
                                Color.gray
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                
                                Text(historyViewModel.historyServiceDetail?.service.shop?.name ?? "")
                                    .font(AppFont.Nunito.footnoteLarge)
                                    .foregroundStyle(Color("tertiary"))
                                
                                Text(historyViewModel.historyServiceDetail?.service.name ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .foregroundColor(.black)
                                
                                Text("\(historyViewModel.historyServiceDetail?.price.formatPrice() ?? "")")
                                    .font(AppFont.Nunito.bodyMedium)
                            }
                            
                            Spacer()
                            
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .padding(.vertical)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Detail Acara")
                                .font(AppFont.Nunito.bodyLarge)
                                .bold()
                                .padding(.bottom, 4)
                            
                            HStack {
                                Text("Nama Acara")
                                    .frame(width: 140, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text(historyViewModel.historyServiceDetail?.activity_name ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Tanggal Acara")
                                    .frame(width: 140, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text(historyViewModel.historyServiceDetail?.activity_date ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Waktu Acara")
                                    .frame(width: 140, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text(historyViewModel.historyServiceDetail?.activity_time ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack(alignment: .top) {
                                Text("Lokasi")
                                    .frame(width: 140, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text("\(historyViewModel.historyServiceDetail?.address ?? "")")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack(alignment: .top) {
                                Text("Peserta")
                                    .frame(width: 140, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text("\(historyViewModel.historyServiceDetail?.attendee ?? 0)")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack(alignment: .top) {
                                Text("Catatan")
                                    .frame(width: 140, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text("\(historyViewModel.historyServiceDetail?.description ?? "")")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            Text("Info Penanggung Jawab")
                                .font(AppFont.Nunito.bodyLarge)
                                .bold()
                                .padding(.vertical, 4)
                                .padding(.top, 7)
                            
                            HStack(alignment: .top) {
                                Text("Nama")
                                    .frame(width: 70, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text(historyViewModel.historyServiceDetail?.name ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack(alignment: .top) {
                                Text("Telepon")
                                    .frame(width: 70, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text(historyViewModel.historyServiceDetail?.phone ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack(alignment: .top) {
                                Text("Address")
                                    .frame(width: 70, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text(historyViewModel.historyServiceDetail?.address ?? "")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            Text("Rincian Pembayaran")
                                .font(AppFont.Nunito.bodyLarge)
                                .bold()
                                .padding(.vertical, 4)
                                .padding(.top, 7)
                            
                            HStack {
                                Text("Total Harga")
                                    .frame(width: 200, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text("\(historyViewModel.historyServiceDetail?.price.formatPrice() ?? "")")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Total Biaya Layanan")
                                    .frame(width: 200, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                Text("Rp5.000")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Total Pembayaran")
                                    .frame(width: 200, alignment: .leading)
                                    .font(AppFont.Nunito.bodyLarge)
                                    .fontWeight(.light)
                                
                                if let price = historyViewModel.historyServiceDetail?.price {
                                    Text("\((price + 5000).formatPrice())")
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.semibold)
                                } else {
                                    Text("")
                                }

                            }
                            
                            if historyViewModel.historyServiceDetail?.computedStatus == "pending" {
                                Button(action: {
                                    if let url = URL(string: historyViewModel.historyProductDetail?.invoice_url ?? "") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Text("Bayar")
                                        .font(AppFont.Nunito.bodyLarge)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color("primary"))
                                        .cornerRadius(10)
                                        .padding(.vertical, 10)
                                }
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal)
                }
                .onAppear{
                    historyViewModel.getDetailHistoryService(idHistory: idHistory)
                }
                .refreshable {
                    historyViewModel.getDetailHistoryService(idHistory: idHistory)
                }
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(AppFont.Crimson.bodyLarge)
                                .frame(width: 40, height: 40)
                                .background(Color.brown.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .tint(Color("tertiary"))
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Detail Transaksi")
                            .font(AppFont.Crimson.bodyLarge)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                }
            }
            if historyViewModel.isLoading {
                Loading(opacity: 1)
                    .zIndex(1)
            }
        }
    }
    
}
