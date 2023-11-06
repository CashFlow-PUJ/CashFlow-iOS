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

  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ApplicationDelegate.shared.application(
      app,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
    return true
  }
}

class Coordinator: ObservableObject {

    var appDIContainer = AppDIContainer()
    @Published var path = [Route]()
    @Published var currentRoute: Route? = nil

    func setup() {
        if Auth.auth().currentUser != nil {
            self.currentRoute = .transactionLog
        }
    }
}



@main
struct CashFlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var coordinator = Coordinator()
    var userProfile = UserProfile()
    let sharedData = SharedData()

    func setup() {
        coordinator.setup()
        Auth.auth().currentUser?.getIDTokenResult(completion: { (tokenResult, error) in
            if let error = error {
                print("Error getting token: \(error.localizedDescription)")
                return
            }

            if let token = tokenResult?.token {
                sharedData.userId = token
                DispatchQueue.main.async {
                    withAnimation {
                        self.coordinator.currentRoute = .transactionLog
                    }
                }
            }
        })
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack {
                    if Auth.auth().currentUser != nil {
                        if sharedData.userId.isEmpty {
                            // Display a loading indicator while the token is being loaded
                            ProgressView()
                                .onAppear {
                                    // Wait until the token is loaded before displaying the EntryLogView
                                    Auth.auth().currentUser?.getIDTokenResult(completion: { (tokenResult, error) in
                                        if let error = error {
                                            print("Error getting token: \(error.localizedDescription)")
                                            return
                                        }

                                        if let token = tokenResult?.token {
                                            sharedData.userId = token
                                            DispatchQueue.main.async {
                                                withAnimation {
                                                    self.coordinator.currentRoute = .transactionLog
                                                }
                                            }
                                        }
                                    })
                                }
                        } else {
                            // Display the EntryLogView when the token is loaded
                            EntryLogView(coordinator: coordinator, sharedData: sharedData)
                                .preferredColorScheme(.light)
                                .navigationBarBackButtonHidden(true)
                                .navigationDestination(for: Route.self) { route in
                                    switch route {
                                    case .transactionLog:
                                        EntryLogView(coordinator: coordinator, sharedData: sharedData)
                                            .preferredColorScheme(.light)
                                            .navigationBarBackButtonHidden(true)
                                    case .login:
                                        EmptyView()
                                    }
                                }
                        }
                    } else {
                        // Display the LoginView if the user is not logged in
                        LoginView()
                            .preferredColorScheme(.light)
                            .navigationBarBackButtonHidden(true)
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .transactionLog:
                                    EmptyView()
                                case .login:
                                    LoginView()
                                        .preferredColorScheme(.light)
                                        .navigationBarBackButtonHidden(true)
                                }
                            }
                    }
                }
            }
            .onAppear(perform: setup)
            .environmentObject(userProfile)
            .environmentObject(sharedData)
            .environmentObject(coordinator)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
