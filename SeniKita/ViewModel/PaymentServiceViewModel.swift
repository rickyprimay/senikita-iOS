//
//  PaymentServiceViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 03/05/25.
//

import Foundation
import Alamofire

class PaymentServiceViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var isLoading: Bool = false
    
    func payment() {
        
        DispatchQueue.main.async { self.isLoading = true }
        
        
    }
    
}
