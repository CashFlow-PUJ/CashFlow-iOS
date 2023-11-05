//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI
import FBSDKCoreKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum Route: Hashable {
    case transactionLog
    case login
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        return true
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
}

class Coordinator: ObservableObject {
    
    var appDIContainer = AppDIContainer()
    @Published var path = [Route]()
    
}

@main
struct CashFlowApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var coordinator = Coordinator()
    var userProfile = UserProfile()
    let sharedData = SharedData()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                LoginView()
                    .preferredColorScheme(.light)
                    .navigationDestination(for: Route.self) { route in
                        Group {
                            switch route {
                            case .transactionLog:
                                EntryLogView(coordinator: coordinator, sharedData: sharedData)
                                    .preferredColorScheme(.light)
                            case .login:
                                LoginView()
                                    .preferredColorScheme(.light)
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                    }
            }
            .environmentObject(userProfile)
            .environmentObject(sharedData)
            .environmentObject(coordinator)
            .onAppear {
                if Auth.auth().currentUser != nil {
                    // DEBUG PRINT
                    print("USUARIO AUTENTICADO: ", Auth.auth().currentUser?.uid as Any)
                    sharedData.userId = Auth.auth().currentUser!.uid
                    coordinator.path.append(.transactionLog)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
