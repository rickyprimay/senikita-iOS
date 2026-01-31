//
//  PaymentServiceViewModel.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import SwiftUI
import UserNotifications

@MainActor
class PaymentServiceViewModel: ObservableObject {
    
    private let orderRepository: OrderRepositoryProtocol
    
    @Published var isLoading: Bool = false
    @Published var isCheckoutSuccess: Bool = false
    
    init(orderRepository: OrderRepositoryProtocol? = nil) {
        self.orderRepository = orderRepository ?? DIContainer.shared.orderRepository
    }
    
    func payment(name: String, serviceId: Int, activityName: String, phone: Int, activityDate: Date, activityTime: Date, province_id: Int, city_id: Int, address: String, attendee: Int, description: String) {
        isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        Task {
            do {
                _ = try await orderRepository.checkoutService(
                    name: name,
                    serviceId: serviceId,
                    activityName: activityName,
                    phone: String(phone),
                    activityDate: dateFormatter.string(from: activityDate),
                    activityTime: timeFormatter.string(from: activityTime),
                    provinceId: province_id,
                    cityId: city_id,
                    address: address,
                    attendee: attendee,
                    description: description
                )
                
                self.isLoading = false
                self.isCheckoutSuccess = true
                self.sendCheckoutSuccessNotification()
            } catch {
                print("Order failed: \(error.localizedDescription)")
                self.isLoading = false
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
            }
        }
    }
}
