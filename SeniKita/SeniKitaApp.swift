//
//  SeniKitaApp.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI
import GoogleSignIn
import UserNotifications

@main
struct SeniKitaApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if authViewModel.isAuthenticated {
                    RootView()
                        .environmentObject(authViewModel)
                } else {
                    Login()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestPermissionNotification() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                if success {
                    print("Notification permission granted")
                    UserDefaults.standard.set(true, forKey: "notificationPermissionGranted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
}
