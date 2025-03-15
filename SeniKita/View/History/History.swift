//
//  History.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 13/03/25.
//

import SwiftUI

struct History: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var historyViewModel = HistoryViewModel()
    
    @State private var selectedTab: String = "Produk Kesenian"
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TabButton(title: "Produk Kesenian", selectedTab: $selectedTab)
                    TabButton(title: "Jasa Kesenian", selectedTab: $selectedTab)
                }
                .background(Color.white)
                
                ScrollView {
                    VStack {
                        if selectedTab == "Produk Kesenian" {
                            if historyViewModel.history.isEmpty && !historyViewModel.isLoading {
                                Text("Tidak ada riwayat pembelian\nProduk Kesenian")
                                    .font(AppFont.Nunito.bodyLarge)
                                    .foregroundColor(Color("primary"))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity)
                            } else {
                                ForEach(historyViewModel.history, id: \.id) { item in
                                    HistoryCardProduct(historyViewModel: historyViewModel, historyItem: item)
                                }
                            }
                        } else {
                            Text("Tidak ada riwayat pemesanan\nJasa Kesenian")
                                .font(AppFont.Nunito.bodyLarge)
                                .foregroundColor(Color("primary"))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 16)
                }
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden(true)
                .refreshable {
                    historyViewModel.gethistoryProduct()
                }
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
                        Text("Daftar Transaksi")
                            .font(AppFont.Crimson.bodyLarge)
                            .bold()
                            .foregroundColor(Color("tertiary"))
                    }
                }
            }
            
            if historyViewModel.isLoading {
                Loading(opacity: 0.5)
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    NavigationView {
        History()
    }
}
