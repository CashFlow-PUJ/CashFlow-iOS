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
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    @StateObject private var vm = AuthViewModel()
    
    private let facebookAuthentication = FacebookAuthentication()

    var credentialFieldsAreEmpty: Bool {
        return (email.isEmpty || password.isEmpty)
    }

    var loginButtonColor: Color {
        return !credentialFieldsAreEmpty ? Color(hex: 0xF75E68) : Color(UIColor.lightGray)
    }
    
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
                        showingErrorAlert = true
                        errorMessage = error.errorMessage
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
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Aceptar")))
            }
            .disabled(credentialFieldsAreEmpty)
            .background(loginButtonColor)
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
                    loginWithFacebook() { result in
                        switch result {
                        // TODO: Replace '.imageInput' with '.transactionLog' whenever imageInput OCR on-device functionality has been implemented.
                        case .success(_):
                            coordinator.path.append(.imageInput)
                        case .failure(let error):
                            showingErrorAlert = true
                            errorMessage = error.localizedDescription
                        }
                    }
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
                    .navigationBarBackButtonHidden(true)
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
                print(error.localizedDescription)
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
    
    func loginWithFacebook(completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        facebookAuthentication.loginFacebook { result in
            switch result {
            case .success(let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                Auth.auth().signIn(with: credential) { authDataResult, error in
                    if let error = error {
                        print("Error creating a new user \(error.localizedDescription)")
                        completionBlock(.failure(error))
                        return
                    }
                    let email = authDataResult?.user.email ?? "No email"
                    print("New user created with info \(email)")
                    completionBlock(.success(true))
                }
            case .failure(let error):
                print("Error signIn with Facebook \(error.localizedDescription)")
                completionBlock(.failure(error))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
