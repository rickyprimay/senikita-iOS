//
//  NotificationManager.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 31/01/26.
//
import Foundation
import UserNotifications
import UIKit


final class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        notificationCenter.requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Notification permission error: \(error.localizedDescription)")
                    completion?(false)
                    return
                }
                
                if granted {
                    print("✅ Notification permission granted")
                    UserDefaults.standard.set(true, forKey: "notificationPermissionGranted")
                } else {
                    print("⚠️ Notification permission denied")
                }
                
                completion?(granted)
            }
        }
    }
    
    
    func checkPermissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    
    func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        timeInterval: TimeInterval,
        repeats: Bool = false,
        userInfo: [AnyHashable: Any] = [:]
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: repeats
        )
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled: \(identifier)")
            }
        }
    }
    
    
    func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        date: Date,
        repeats: Bool = false,
        userInfo: [AnyHashable: Any] = [:]
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: repeats
        )
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for \(date): \(identifier)")
            }
        }
    }
    
    
    func cancelNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
        print("🗑️ Notification cancelled: \(identifier)")
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        print("🗑️ All notifications cancelled")
    }
    
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    
    func setBadgeCount(_ count: Int) {
        Task { @MainActor in
            if #available(iOS 16.0, *) {
                try? await notificationCenter.setBadgeCount(count)
            } else {
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }
    }
    
    func clearBadge() {
        setBadgeCount(0)
    }
}


enum NotificationIdentifier {
    static let orderStatus = "order_status"
    static let cartReminder = "cart_reminder"
    static let promotional = "promotional"
    static let serviceUpdate = "service_update"
}
