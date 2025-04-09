//
//  AddressSelectionSheet.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 09/04/25.
//

import SwiftUI

struct AddressSelectionSheet: View {
    let addresses: [Address]
    @Binding var selectedAddress: Address?
    @Environment(\.presentationMode) var presentationMode
    @Binding var cityId: Int
    @ObservedObject var paymentViewModel: PaymentViewModel
    var originId: Int
    @Binding var selectedShipping: String
    
    var body: some View {
        VStack {
            Text("Pilih Alamat")
                .font(AppFont.Nunito.titleMedium)
                .bold()
                .padding()
            
            ScrollView {
                VStack {
                    ForEach(addresses, id: \.id) { address in
                        VStack(alignment: .leading, spacing: 4) {
                            AddressPaymentCard(address: address)
                                .onTapGesture {
                                    selectedShipping = "Pilih Pengiriman"
                                    selectedAddress = address
                                    presentationMode.wrappedValue.dismiss()
                                    cityId = address.city_id
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        paymentViewModel.getOngkirCost(originId: originId, destination: cityId) { success, message in
                                            if success {
                                                print("Biaya ongkir diperbarui setelah mengganti alamat")
                                            } else {
                                                print("Gagal memperbarui ongkir: \(message)")
                                            }
                                        }
                                    }
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedAddress?.id == address.id ? Color("primary") : Color.gray.opacity(0.4), lineWidth: 2)
                        )
                    }
                }
                .padding()
            }
            
            Button("Tutup") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundStyle(Color("primary"))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding()
        }
    }
}
