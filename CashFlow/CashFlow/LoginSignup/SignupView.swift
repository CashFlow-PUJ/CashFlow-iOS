//
//  SignupView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/08/23.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    
    // TODO: Remove back button from this screen.
    
    @EnvironmentObject var coordinator: Coordinator
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var emailConfirmation: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    @StateObject private var vm = AuthViewModel()
    
    var body: some View {
        VStack {
            Text("Crea tu cuenta")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Email Input
            TextField("Correo electrónico", text: $email)
                .keyboardType(.emailAddress)
                .padding(.top, 5)
                .autocapitalization(.none)
            
            // Confirm Email Input
            // TODO: Check for equality between emails and if not, display message on screen.
            TextField("Confirma tu correo electrónico", text: $emailConfirmation)
                .keyboardType(.emailAddress)
                .padding(.top, 15)
                .autocapitalization(.none)
            
            // Password Input
            SecureField("Contraseña", text: $password)
                .padding(.top, 15)
            
            // Confirm Password Input
            // TODO: Check for equality between passwords and if not, display message on screen.
            SecureField("Confirma tu contraseña", text: $passwordConfirmation)
                .padding(.top, 15)
            
            // Log in Button
            Button(action: {
                vm.signUp(email: email, password: password) { result in
                    switch result {
                        case .success(_):
                            coordinator.path.append(.transactionLog)
                        case .failure(let error):
                            print(error.errorMessage)
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
            .background(Color(hex: 0xF75E68))
            .cornerRadius(8)
            .padding(.top, 20)
            
            Text("O registrate con")
                .foregroundColor(.gray)
                .padding(.vertical, 10)
            
            // Facebook, Google, etc. Buttons
            HStack {
                Button(action: {
                    // TODO: Google authentication integration.
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
            
            // TODO: Policy Checkbox
            
            Button("¿Ya tienes una cuenta?"){
                dismiss()
            }
            .foregroundColor(Color(hex: 0xF75E68))
            .padding(.top, 20)
        }
        .padding(37)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
