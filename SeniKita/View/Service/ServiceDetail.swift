//
//  ServiceDetail.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 07/03/25.
//

import SwiftUI

struct ServiceDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var productViewModel = ProductViewModel()
    var idProduct: Int
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                }
            }
            .onAppear{
                productViewModel.fetchProductById(idProduct: idProduct, isLoad: true)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .tint(Color("tertiary"))
                }
                ToolbarItem(placement: .principal) {
                    Text("Detail Product")
                        .font(AppFont.Crimson.bodyLarge)
                        .bold()
                        .foregroundColor(Color("tertiary"))
                }
            }
        }
    }
    
}
