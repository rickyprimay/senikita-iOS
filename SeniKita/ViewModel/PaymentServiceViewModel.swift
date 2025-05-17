//
//  PaymentServiceViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 03/05/25.
//

import Foundation
import Alamofire
import SwiftUI

class PaymentServiceViewModel: ObservableObject {
    
    let baseUrl = "https://api.senikita.my.id/api/"
    
    @Published var isLoading: Bool = false
    @Published var isCheckoutSuccess: Bool = false
    
    func payment(name: String, serviceId: Int, activityName: String, phone: Int, activityDate: Date, activityTime: Date, province_id: Int, city_id: Int, address: String, attendee: Int, description: String) {
        DispatchQueue.main.async { self.isLoading = true }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let url = "\(baseUrl)user/order-service"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let parameters: [String: Any] = [
            "name": name,
            "service_id": serviceId,
            "activity_name": activityName,
            "phone": String(phone),
            "qty": 1,
            "activity_date": dateFormatter.string(from: activityDate),
            "activity_time": timeFormatter.string(from: activityTime),
            "province_id": province_id,
            "city_id": city_id,
            "address": address,
            "attendee": attendee,
            "description": description
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async { self.isLoading = false }
                
                switch response.result {
                case .success(let data):
                    print("Order success: \(String(data: data, encoding: .utf8) ?? "")")
                    DispatchQueue.main.async {
                        self.isCheckoutSuccess = true
                        self.sendCheckoutSuccessNotification()
                    }
                case .failure(let error):
                    print("Order failed: \(error.localizedDescription)")
                    if let data = response.data {
                        print("Server response: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                }
            }
        
    }
    
    func sendCheckoutSuccessNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pemesanan Berhasil!"
        content.body = "Terima kasih telah melakukan pemesanan. proses selanjutnya silahkan lanjutkan ke pembayaran"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Checkout success notification sent!")
            }
        }
    }
    
}
