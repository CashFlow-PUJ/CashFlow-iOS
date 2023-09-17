//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum Route: Hashable {
    case transactionLog
    case imageInput
    case login
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
                        Group {
                            switch route {
                            case .transactionLog:
                                TransactionLogView()
                                    .preferredColorScheme(.light)
                                    .environmentObject(coordinator)
                            case .imageInput:
                                ImageInputView()
                                    .preferredColorScheme(.light)
                                    .environmentObject(coordinator)
                            case .login:
                                LoginView()
                                    .preferredColorScheme(.light)
                                    .environmentObject(coordinator)
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                    }
            }
            .onAppear {
                if Auth.auth().currentUser != nil {
                    // TODO: Replace imageInput when transactionLog implementation starts and is linked to imageInput trigger button.
                    coordinator.path.append(.imageInput)
                }
            }
            .environmentObject(coordinator)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
