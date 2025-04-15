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
        ["Pilih Pengiriman"] + paymentViewModel.ongkir.map { "\($0.description) - Rp. \($0.cost.first?.value ?? 0)" }
    }
    
    var selectedShippingCost: Int {
        if let selectedOption = paymentViewModel.ongkir.first(where: { "\($0.description) - Rp. \($0.cost.first?.value ?? 0)" == selectedShipping }) {
            return selectedOption.cost.first?.value ?? 0
        }
        return 0
    }
    
    var totalOrderPrice: Int {
        return totalPriceOrder + selectedShippingCost + 5000
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            if let url = URL(string: storeAvatar), !storeAvatar.isEmpty {
                                WebImage(url: url)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                    .clipShape(Circle())
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(storeName)
                                    .font(AppFont.Raleway.bodyLarge)
                                Text(storeLocation)
                                    .font(AppFont.Raleway.bodyMedium)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        HStack {
                            if productImage != "" {
                                WebImage(url: URL(string: productImage))
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                    .clipShape(Circle())
                                    .scaledToFit()
                            } else {
                                Color.gray
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(productName)
                                    .font(AppFont.Nunito.bodyMedium)
                                
                                Text("\(productQty) item x Rp\(productPrice)")
                                    .font(AppFont.Nunito.footnoteLarge)
                                    .foregroundColor(.gray)
                                Text("\(totalPriceOrder)")
                                    .font(AppFont.Nunito.footnoteLarge)
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        
                        VStack {
                            Picker(
                                "Pilih Pengiriman", selection: $selectedShipping
                            ) {
                                ForEach(shippingOptions, id: \.self) { option in
                                    HStack(spacing: 4) {
                                        Image(systemName: "truck.box")
                                        Text(option)
                                    }
                                    .font(AppFont.Nunito.bodyMedium)
                                }
                            }
                            .accentColor(Color("primary"))
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .background(Color("tertiary").opacity(0.3))
                            .cornerRadius(8)
                            .onChange(of: selectedShipping) {
                                if let selectedOption = paymentViewModel.ongkir.first(where: {
                                    "\($0.description) - Rp. \($0.cost.first?.value ?? 0)" == selectedShipping
                                }) {
                                    selectedService = selectedOption.service
                                } else {
                                    selectedService = ""
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Alamat Anda")
                                .font(AppFont.Nunito.bodyMedium)
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                showAddressSheet.toggle()
                            } label: {
                                Text("Ganti alamat")
                                    .font(AppFont.Nunito.bodyMedium)
                                    .bold()
                                    .foregroundColor(Color("primary"))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if let firstAddress = paymentViewModel.firstAddress, !paymentViewModel.address.isEmpty {
                                AddressPaymentCard(address: firstAddress)
                            } else {
                                Text("Anda belum memiliki alamat")
                                    .font(AppFont.Nunito.bodyMedium)
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("primary"), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Ringkasan Belanja")
                            .font(AppFont.Nunito.bodyMedium)
                            .bold()
                        
                        HStack {
                            Text("Total Harga")
                                .font(AppFont.Raleway.bodyMedium)
                            Spacer()
                            Text("\(totalPriceOrder)")
                                .font(AppFont.Nunito.bodyMedium)
                        }
                        
                        HStack {
                            Text("Biaya Layanan")
                                .font(AppFont.Raleway.bodyMedium)
                            Spacer()
                            Text("Rp5.000")
                                .font(AppFont.Nunito.bodyMedium)
                        }
                        
                        if selectedShipping != "Pilih Pengiriman" {
                            HStack {
                                Text("Biaya Ongkir")
                                    .font(AppFont.Raleway.bodyMedium)
                                Spacer()
                                Text("Rp\(selectedShippingCost)")
                                    .font(AppFont.Nunito.bodyMedium)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total Belanja")
                                .font(AppFont.Raleway.bodyMedium)
                                .bold()
                            Spacer()
                            Text("Rp\(totalOrderPrice)")
                                .font(AppFont.Nunito.bodyMedium)
                        }
                        
                        Button{
                            
                            let addressId = paymentViewModel.firstAddress?.id ?? 0
                            let addressNote = paymentViewModel.firstAddress?.note ?? ""
                            
                            print("== Checkout Params ==")
                            print("Product IDs: [\(productId)]")
                            print("Qtys: [\(productQty)]")
                            print("Courier: JNE")
                            print("Service: REG")
                            print("Address ID: \(addressId)")
                            print("Note: \(addressNote)")
                            
                            paymentViewModel.makeCheckout(
                                productIDs: [productId],
                                qtys: [productQty],
                                courier: "jne",
                                service: selectedService,
                                addressID: addressId,
                                note: paymentViewModel.firstAddress?.note ?? ""
                            )
                            
                        } label: {
                            Text("Checkout")
                                .font(AppFont.Raleway.bodyMedium)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 40)
                                .background(Color("primary"))
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                        
                    }
                    .padding()
                    
                }
            }
            .onAppear{
                paymentViewModel.getAddress()
            }
            .onReceive(paymentViewModel.$isAddressLoaded) { loaded in
                if loaded {
                    self.cityId = paymentViewModel.firstAddress!.city_id
                    paymentViewModel.getOngkirCost(originId: originId, destination: cityId) { success, message in
                        if success {
                            print("Berhasil mengambil data ongkir dan cost")
                        } else {
                            print("Gagal mengambil data ongkir dan cost: \(message)")
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
                    Text("Checkout")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("tertiary"))
                }
            }
            .sheet(isPresented: $showAddressSheet) {
                AddressSelectionSheet(addresses: paymentViewModel.address, selectedAddress: $paymentViewModel.firstAddress, cityId: $cityId, paymentViewModel: paymentViewModel, originId: originId, selectedShipping: $selectedShipping)
            }
            
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
    }
    
}



//#Preview {
//    NavigationView{
//        Payment()
//    }
//}
