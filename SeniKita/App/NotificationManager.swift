//
//  NotificationManager.swift
//  SeniKita
//

import Foundation
import UserNotifications
import UIKit

// MARK: - Notification Manager
// Handles local and push notification management
final class NotificationManager {
    // MARK: - Singleton
    static let shared = NotificationManager()
    
    // MARK: - Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    // MARK: - Permission
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
    
    // MARK: - Check Permission Status
    func checkPermissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    // MARK: - Schedule Local Notification
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
    
    // MARK: - Schedule Date Notification
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
    
    // MARK: - Cancel Notifications
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
    
    // MARK: - Get Pending Notifications
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    // MARK: - Badge Management
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

// MARK: - Notification Identifiers
enum NotificationIdentifier {
    static let orderStatus = "order_status"
    static let cartReminder = "cart_reminder"
    static let promotional = "promotional"
    static let serviceUpdate = "service_update"
}
