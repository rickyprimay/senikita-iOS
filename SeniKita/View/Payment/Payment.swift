//
//  Payment.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 22/03/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct Payment: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var paymentViewModel = PaymentViewModel()
    
    let storeAvatar: String
    let storeName: String
    let storeLocation: String
    let productId: Int
    let productImage: String
    let productName: String
    let productPrice: Int
    let productQty: Int
    let originId: Int
    
    var totalPriceOrder: Int {
        return productPrice * productQty
    }
    
    @State private var cityId: Int = 0
    @State private var selectedShipping: String = "Pilih Pengiriman"
    @State private var selectedService: String = ""
    @State private var showAddressSheet = false
    @State private var showPopup = false
    @State private var popupMessage = ""
    @State private var navigateToHistory = false
    
    var shippingOptions: [String] {
        ["Pilih Pengiriman"] + paymentViewModel.ongkir.map { "\($0.description) - Rp\(formatPrice($0.cost.first?.value ?? 0))" }
    }
    
    var selectedShippingCost: Int {
        if let selectedOption = paymentViewModel.ongkir.first(where: { "\($0.description) - Rp\(formatPrice($0.cost.first?.value ?? 0))" == selectedShipping }) {
            return selectedOption.cost.first?.value ?? 0
        }
        return 0
    }
    
    var totalOrderPrice: Int {
        return totalPriceOrder + selectedShippingCost + 5000
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Store & Product Card
                        storeProductCard
                        
                        // Address Card
                        addressCard
                        
                        // Order Summary Card
                        orderSummaryCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
            
            // Checkout Button
            checkoutButton
            
            if paymentViewModel.isLoading {
                Loading(opacity: 0.5)
            }
            
            if showPopup {
                BasePopup(
                    isShowing: $showPopup,
                    message: popupMessage,
                    onConfirm: {
                        showPopup = false
                        navigateToHistory = true
                    },
                    isSuccess: true
                )
            }
            
            NavigationLink(destination: History(isFromPayment: true), isActive: $navigateToHistory) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            paymentViewModel.getAddress()
        }
        .onReceive(paymentViewModel.$isAddressLoaded) { loaded in
            if loaded {
                if let address = paymentViewModel.firstAddress {
                    self.cityId = address.city_id
                    paymentViewModel.getOngkirCost(originId: originId, destination: cityId) { success, message in
                        if success {
                            print("Berhasil mengambil data ongkir dan cost")
                        } else {
                            print("Gagal mengambil data ongkir dan cost: \(message)")
                        }
                    }
                }
            }
        }
        .onReceive(paymentViewModel.$isCheckoutSuccess) { success in
            if success {
                popupMessage = "Pemesanan Berhasil, Lanjut ke Pembayaran?"
                showPopup = true
            }
        }
        .sheet(isPresented: $showAddressSheet) {
            AddressSelectionSheet(
                addresses: paymentViewModel.address,
                selectedAddress: $paymentViewModel.firstAddress,
                cityId: $cityId,
                paymentViewModel: paymentViewModel,
                originId: originId,
                selectedShipping: $selectedShipping
            )
        }
        .hideTabBar()
    }
    
    // MARK: - Navigation Header
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
            
            Text("Checkout")
                .font(AppFont.Nunito.subtitle)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Invisible spacer for balance
            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Store & Product Card
    private var storeProductCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Store info
            HStack(spacing: 12) {
                if let url = URL(string: storeAvatar), !storeAvatar.isEmpty {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                        )
                } else {
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 48, height: 48)
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(storeName)
                        .font(AppFont.Nunito.bodyLarge)
                        .foregroundColor(.primary)
                    Text(storeLocation)
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Product info
            HStack(spacing: 12) {
                if !productImage.isEmpty {
                    WebImage(url: URL(string: productImage))
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "cube.box")
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(productName)
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text("\(productQty) item x Rp\(formatPrice(productPrice))")
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(.secondary)
                    
                    Text("Rp\(formatPrice(totalPriceOrder))")
                        .font(AppFont.Nunito.bodyLarge)
                        .foregroundColor(Color("primary"))
                }
                
                Spacer()
            }
            .padding(12)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            
            // Shipping Picker
            VStack(alignment: .leading, spacing: 8) {
                Picker("Pilih Pengiriman", selection: $selectedShipping) {
                    ForEach(shippingOptions, id: \.self) { option in
                        HStack(spacing: 6) {
                            Image(systemName: "truck.box")
                            Text(option)
                        }
                        .font(AppFont.Raleway.bodyMedium)
                    }
                }
                .accentColor(Color("primary"))
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("tertiary").opacity(0.5), lineWidth: 1)
                )
                .onChange(of: selectedShipping) {
                    if let selectedOption = paymentViewModel.ongkir.first(where: {
                        "\($0.description) - Rp\(formatPrice($0.cost.first?.value ?? 0))" == selectedShipping
                    }) {
                        selectedService = selectedOption.service
                    } else {
                        selectedService = ""
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Address Card
    private var addressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Alamat Pengiriman")
                    .font(AppFont.Nunito.bodyLarge)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    showAddressSheet.toggle()
                } label: {
                    Text("Ganti")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(Color("primary"))
                }
            }
            
            if let firstAddress = paymentViewModel.firstAddress, !paymentViewModel.address.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(firstAddress.label_address.uppercased())
                        .font(AppFont.Raleway.footnoteSmall)
                        .foregroundColor(Color("primary"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("tertiary").opacity(0.2))
                        .cornerRadius(6)
                    
                    Text(firstAddress.name)
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                    
                    Text(firstAddress.phone)
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.secondary)
                    
                    Text(firstAddress.address_detail)
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    if let note = firstAddress.note, !note.isEmpty {
                        Text(note)
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.system(size: 24))
                        .foregroundColor(.red.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Belum Ada Alamat")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.primary)
                        
                        Text("Tambahkan alamat pengiriman")
                            .font(AppFont.Raleway.footnoteSmall)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.red.opacity(0.05))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Order Summary Card
    private var orderSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ringkasan Pesanan")
                .font(AppFont.Nunito.bodyLarge)
                .foregroundColor(.primary)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Subtotal Produk")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Rp\(formatPrice(totalPriceOrder))")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Biaya Layanan")
                        .font(AppFont.Raleway.bodyMedium)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Rp\(formatPrice(5000))")
                        .font(AppFont.Nunito.bodyMedium)
                        .foregroundColor(.primary)
                }
                
                if selectedShipping != "Pilih Pengiriman" {
                    HStack {
                        Text("Biaya Ongkir")
                            .font(AppFont.Raleway.bodyMedium)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Rp\(formatPrice(selectedShippingCost))")
                            .font(AppFont.Nunito.bodyMedium)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Total Pembayaran")
                    .font(AppFont.Nunito.bodyLarge)
                    .foregroundColor(.primary)
                Spacer()
                Text("Rp\(formatPrice(totalOrderPrice))")
                    .font(AppFont.Nunito.headerMedium)
                    .foregroundColor(Color("primary"))
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - Checkout Button
    private var checkoutButton: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button {
                let addressId = paymentViewModel.firstAddress?.id ?? 0
                
                paymentViewModel.makeCheckout(
                    productIDs: [productId],
                    qtys: [productQty],
                    courier: "jne",
                    service: selectedService,
                    addressID: addressId
                )
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 16))
                    Text("Bayar Sekarang")
                        .font(AppFont.Nunito.bodyLarge)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("primary"), Color("tertiary")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: Color("primary").opacity(0.3), radius: 8, y: 4)
            }
            .disabled(selectedShipping == "Pilih Pengiriman" || paymentViewModel.firstAddress == nil)
            .opacity(selectedShipping == "Pilih Pengiriman" || paymentViewModel.firstAddress == nil ? 0.6 : 1.0)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 30)
            .background(Color.white)
        }
    }
    
    // MARK: - Helper
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
