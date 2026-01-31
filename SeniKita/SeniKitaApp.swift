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
            Group {
                let _ = print("🏠 [SeniKitaApp] body evaluated - isAuthenticated: \(authViewModel.isAuthenticated)")
                if authViewModel.isAuthenticated {
                    let _ = print("🏠 [SeniKitaApp] Showing RootView")
                    RootView()
                        .environmentObject(authViewModel)
                } else {
                    let _ = print("🏠 [SeniKitaApp] Showing Login")
                    NavigationStack {
                        Login()
                            .environmentObject(authViewModel)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
            .onChange(of: authViewModel.isAuthenticated) { oldValue, newValue in
                print("🏠 [SeniKitaApp] isAuthenticated CHANGED from \(oldValue) to \(newValue)")
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
