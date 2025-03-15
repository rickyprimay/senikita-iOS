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
            VStack{
                ScrollView {
                    VStack(alignment: .leading) {
                        if let statusInfo = statusMap[historyViewModel.historyProductDetail?.computedStatus ?? "selesai"] {
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
                            Text(historyViewModel.historyProductDetail?.no_transaction ?? "")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Tanggal Pembelian")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.light)
                            Spacer()
                            Text(historyViewModel.historyProductDetail?.created_at.formattedDateWithTime() ?? "")
                                .font(AppFont.Nunito.bodyLarge)
                                .fontWeight(.bold)
                        }
                        HStack(spacing: 12) {
                            if let imageUrl = URL(string: historyViewModel.historyProductDetail?.product.first?.thumbnail ?? "") {
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
                                Text(historyViewModel.historyProductDetail?.product.first?.name ?? "Nama tidak tersedia")
                                    .font(AppFont.Nunito.bodyMedium)
                                    .foregroundColor(.black)
                                
                                Text("\(historyViewModel.historyProductDetail?.product.first?.pivot?.qty ?? 0) item x \((historyViewModel.historyProductDetail?.product.first?.price ?? 0).toDouble().formatPrice())")
                                    .font(AppFont.Nunito.footnoteSmall)
                                    .foregroundColor(Color.gray)
                                
                                Text("\(historyViewModel.historyProductDetail?.price.formatPrice() ?? "")")
                                    .font(AppFont.Nunito.bodyMedium)
                                    .foregroundColor(.black)
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Catatan")
                                .font(AppFont.Nunito.bodyLarge)
                                .bold()
                                .padding(.bottom, 4)
                            
                            Text("Info Pengiriman")
                                .font(AppFont.Nunito.bodyLarge)
                                .bold()
                                .padding(.bottom, 8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Kurir")
                                        .frame(width: 70, alignment: .leading)
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.light)
                                    
                                    Text("\(historyViewModel.historyProductDetail?.courier ?? "") - \(historyViewModel.historyProductDetail?.service ?? "")")
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack {
                                    Text("No. Resi")
                                        .frame(width: 70, alignment: .leading)
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.light)
                                    
                                    Text("Nomor Resi")
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack(alignment: .top) {
                                    Text("Alamat")
                                        .frame(width: 70, alignment: .leading)
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.light)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(historyViewModel.historyProductDetail?.address.name ?? "")
                                            .font(AppFont.Nunito.bodyLarge)
                                            .fontWeight(.bold)
                                        
                                        Text(historyViewModel.historyProductDetail?.address.phone ?? "")
                                            .font(AppFont.Nunito.bodyLarge)
                                            .fontWeight(.semibold)
                                        
                                        Text(historyViewModel.historyProductDetail?.address.address_detail ?? "")
                                            .font(AppFont.Nunito.bodyLarge)
                                            .fontWeight(.semibold)
                                        
                                        Text("\(historyViewModel.historyProductDetail?.address.city?.name ?? ""), \(historyViewModel.historyProductDetail?.address.city?.province?.name ?? "")")
                                            .font(AppFont.Nunito.bodyLarge)
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                Text("Rincian Pembayaran")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .bold()
                                    .padding(.bottom, 8)
                                
                                HStack {
                                    Text("Total Harga")
                                        .frame(width: 200, alignment: .leading)
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.light)
                                    
                                    Text("\(historyViewModel.historyProductDetail?.price.formatPrice() ?? "")")
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack {
                                    Text("Total Ongkos Kirim")
                                        .frame(width: 200, alignment: .leading)
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.light)
                                    
                                    Text("\(historyViewModel.historyProductDetail?.ongkir.formatPrice() ?? "")")
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
                                    
                                    Text("\(historyViewModel.historyProductDetail?.total_price.formatPrice() ?? "")")
                                        .font(AppFont.Nunito.bodyLarge)
                                        .fontWeight(.semibold)
                                }
                                
                                if historyViewModel.historyProductDetail?.computedStatus == "pending" {
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
                    }
                    .padding(.horizontal)
                }
                .onAppear{
                    historyViewModel.getDetailHistoryProduct(idHistory: idHistory)
                }
                .refreshable{
                    historyViewModel.getDetailHistoryProduct(idHistory: idHistory)
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
