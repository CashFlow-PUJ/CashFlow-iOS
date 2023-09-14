//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

enum Route: Hashable {
    case transactionLog
    case imageInput
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
    }
}
 
class Coordinator: ObservableObject {
    @Published var path = [Route]()
}

@main
struct CashFlowApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                LoginView()
                    .preferredColorScheme(.light)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                            case .transactionLog:
                                TransactionLogView()
                                    .preferredColorScheme(.light)
                            case .imageInput:
                                ContentView()
                                    .preferredColorScheme(.light)
                        }
                }
            }.environmentObject(coordinator)
        }
    }
}
