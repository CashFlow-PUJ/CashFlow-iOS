//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CashFlowApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            var userIsAuthenticated = true
            
            // IF USER IS NOT AUTHENTICATED
            if(!userIsAuthenticated) {
                LoginView()
                    .preferredColorScheme(.light)
            }
            else {
                TransactionLogView()
                    .preferredColorScheme(.light)
            }
        }
    }
}
