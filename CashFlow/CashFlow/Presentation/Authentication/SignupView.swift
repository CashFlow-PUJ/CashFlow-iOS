//
//  SignupView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/08/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FacebookLogin

struct SignupView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var emailConfirmation: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    @StateObject private var vm = AuthViewModel()
    
    private let facebookAuthentication = FacebookAuthentication()
    
    var credentialFieldsAreEmpty: Bool {
        return (email.isEmpty || password.isEmpty) || (emailConfirmation.isEmpty || passwordConfirmation.isEmpty)
    }
    
    var credentialFieldsDontMatch: Bool {
        return (email != emailConfirmation || password != passwordConfirmation)
    }

    var signupButtonColor: Color {
        return !credentialFieldsAreEmpty && !credentialFieldsDontMatch ? Color(hex: 0xF75E68) : Color(UIColor.lightGray)
    }
    
    var body: some View {
        VStack {
            Text("Crea tu cuenta")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Email Input
            Group {
                TextField("Correo electrónico", text: $email)
                    .keyboardType(.emailAddress)
                    .padding(.top, 5)
                    .autocapitalization(.none)
                
                // Confirm Email Input
                TextField("Confirma tu correo electrónico", text: $emailConfirmation)
                    .keyboardType(.emailAddress)
                    .padding(.vertical, 15)
                    .autocapitalization(.none)
                
                fieldsDoNotMatchText(errorMessage: "Los correos no coinciden. 🧐", textFieldString1: email, textFieldString2: emailConfirmation)
            }
            
            // Password Input
            Group {
                SecureField("Contraseña", text: $password)
                    .padding(.top, 5)
                
                // Confirm Password Input
                SecureField("Confirma tu contraseña", text: $passwordConfirmation)
                    .padding(.vertical, 15)
                
                fieldsDoNotMatchText(errorMessage: "Las contraseñas no coinciden. 🫣", textFieldString1: password, textFieldString2: passwordConfirmation)
            }
            
            // Log in Button
            Button(action: {
                vm.signUp(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        // Dismiss the current view
                        dismiss()

                        // Navigate to the EntryLogView
                        DispatchQueue.main.async {
                            withAnimation {
                                coordinator.currentRoute = .transactionLog
                            }
                        }
                    case .failure(let error):
                        showingErrorAlert = true
                        errorMessage = error.errorMessage
                    }
                }
            }) {
                Text("Continuar")
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
            .disabled(credentialFieldsAreEmpty || credentialFieldsDontMatch)
            .background(signupButtonColor)
            .cornerRadius(8)
            .padding(.top, 20)
            
            Text("O registrate con")
                .foregroundColor(.gray)
                .padding(.vertical, 10)
            
            // Facebook, Google, etc. Buttons
            HStack {
                Button(action: {
                    handleGoogleSignUpButton()
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
                        case .success(_):
                            // Dismiss the current view
                            dismiss()

                            // Navigate to the EntryLogView
                            DispatchQueue.main.async {
                                withAnimation {
                                    coordinator.currentRoute = .transactionLog
                                }
                            }
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
            
            // TODO: Policy Checkbox
            
            Button("¿Ya tienes una cuenta?"){
                dismiss()
            }
            .foregroundColor(Color(hex: 0xF75E68))
            .padding(.top, 20)
        }
        .padding(37)
    }
    
    @ViewBuilder
    private func fieldsDoNotMatchText(errorMessage: String, textFieldString1: String, textFieldString2: String) -> some View {
        if textFieldString1 != textFieldString2 && (!textFieldString1.isEmpty && !textFieldString2.isEmpty) {
            Text(errorMessage)
                .font(.callout)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        EmptyView()
    }
    
    private func handleGoogleSignUpButton() {
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
                case .success(_):
                    dismiss()
                    DispatchQueue.main.async {
                        withAnimation {
                            coordinator.currentRoute = .transactionLog
                        }
                    }
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

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
