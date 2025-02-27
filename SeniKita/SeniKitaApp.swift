//
//  SeniKitaApp.swift
//  SeniKita
//
//  Created by Ricky Primayuda Putra on 15/02/25.
//

import SwiftUI

@main
struct SeniKitaApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Splash()
        }
    }
}
