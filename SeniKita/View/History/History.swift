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
    
    var isFromPayment: Bool
    @State private var navigateToRootView = false
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                segmentedControl
                
                TabView(selection: $selectedTab) {
                    productHistoryList
                        .tag(0)
                    
                    serviceHistoryList
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if !isFromPayment {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        navigateToRootView = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("primary"))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Riwayat Transaksi")
                    .font(AppFont.Nunito.subtitle)
                    .foregroundColor(.primary)
            }
        }
        .onChange(of: selectedTab) {
            if selectedTab == 1 {
                historyViewModel.getHistoryService()
            }
        }
        .refreshable {
            if selectedTab == 1 {
                historyViewModel.getHistoryService()
            } else {
                historyViewModel.gethistoryProduct()
            }
        }
        .background(
            NavigationLink(destination: RootView(), isActive: $navigateToRootView) {
                EmptyView()
            }
        )
        .hideTabBar()
    }
    
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            SegmentButton(
                title: "Produk",
                icon: "cube.box.fill",
                isSelected: selectedTab == 0
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 0
                }
            }
            
            SegmentButton(
                title: "Jasa",
                icon: "paintbrush.pointed.fill",
                isSelected: selectedTab == 1
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 1
                }
            }
        }
        .padding(4)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private var productHistoryList: some View {
        ScrollView(showsIndicators: false) {
            if historyViewModel.isLoading {
                LazyVStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        HistoryCardSkeleton()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            } else if historyViewModel.history.isEmpty {
                emptyState(
                    icon: "cube.box",
                    title: "Belum Ada Transaksi",
                    subtitle: "Riwayat pembelian produk kesenian akan muncul di sini"
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(historyViewModel.history, id: \.id) { item in
                        HistoryCardProduct(historyViewModel: historyViewModel, historyItem: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
    }
    
    private var serviceHistoryList: some View {
        ScrollView(showsIndicators: false) {
            if historyViewModel.isLoading {
                LazyVStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        HistoryCardSkeleton()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            } else if historyViewModel.historyService.isEmpty {
                emptyState(
                    icon: "paintbrush.pointed",
                    title: "Belum Ada Transaksi",
                    subtitle: "Riwayat pemesanan jasa kesenian akan muncul di sini"
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(historyViewModel.historyService, id: \.id) { item in
                        HistoryCardService(historyViewModel: historyViewModel, historyItemService: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func emptyState(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .fill(Color("primary").opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color("primary"))
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(AppFont.Nunito.bodyMedium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(AppFont.Raleway.footnoteSmall)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct SegmentButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(title)
                    .font(AppFont.Nunito.footnoteSmall)
            }
            .foregroundColor(isSelected ? .white : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color("primary") : Color.clear)
            .cornerRadius(10)
        }
    }
}
