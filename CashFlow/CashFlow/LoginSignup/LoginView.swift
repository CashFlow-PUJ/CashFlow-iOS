//
//  LoginView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/08/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

// TODO: Check best practice to place extensions and enums in Swift (independent file, etc.)
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct LoginView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    // TODO: Both on this and SignUpView: dismiss keyboard controller when tapping out of TextField or SecureField.
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @StateObject private var vm = AuthViewModel()
    
    var body: some View {
        VStack {
            
            Image("CashFlowLogo")
            
            Text("Inicia sesión")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            
            Text("¡Accede a tu cuenta!")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
            
            // Email Input
            TextField("Correo electrónico", text: $email)
                .keyboardType(.emailAddress)
                .padding(.top, 20)
                .autocapitalization(.none)
            
            // Password Input
            SecureField("Contraseña", text: $password)
                .padding(.vertical, 15)
            
            // Log in Button
            Button(action: {
                vm.logIn(email: email, password: password) { result in
                    switch result {
                        // TODO: Replace '.imageInput' with '.transactionLog' whenever imageInput OCR on-device functionality has been implemented.
                    case .success(_):
                        coordinator.path.append(.imageInput)
                    case .failure(let error):
                        print(error.errorMessage)
                    }
                }
            }) {
                Text("Iniciar sesión")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2))
            }
            .background(Color(hex: 0xF75E68))
            .cornerRadius(8)
            
            Text("Iniciar sesión con")
                .foregroundColor(.gray)
                .padding(.top, 25)
            
            // Facebook, Google, etc. Buttons
            HStack {
                
                Button(action: {
                    handleGoogleSignInButton()
                }) {
                    Text("Google")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2))
                }
                .background(Color(hex: 0x7980F2))
                .cornerRadius(8)
                
                Button(action: {
                    // TODO: Facebook authentication integration-
                }) {
                    Text("Facebook")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2))
                }
                .background(Color(hex: 0x425893))
                .cornerRadius(8)
            }
            
            NavigationLink {
                // TODO: Forgot password View
            } label: {
                Text("¿Olvidaste tu contraseña?")
                    .foregroundColor(Color(hex: 0xF75E68))
            }
            .padding(.top, 25)
            
            NavigationLink {
                SignupView()
                    .preferredColorScheme(.light)
            } label: {
                Text("¿No estás registrado?")
                    .foregroundColor(Color(hex: 0xF75E68))
            }
            .padding(.top, 10)
            
        }
        .padding(37)
    }
    
    private func handleGoogleSignInButton() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { authentication, error in
            
            if let error {
              // TODO: Handle error
            }
                    
            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            vm.logIn(credential: credential) { result in
                switch result {
                    // TODO: Replace '.imageInput' with '.transactionLog' whenever imageInput OCR on-device functionality has been implemented.
                case .success(_):
                    coordinator.path.append(.imageInput)
                case .failure(let error):
                    print(error.errorMessage)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
