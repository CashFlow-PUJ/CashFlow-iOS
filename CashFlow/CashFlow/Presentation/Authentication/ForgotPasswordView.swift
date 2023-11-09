//
//  ForgotPasswordView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 9/11/23.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var showConfirmationAlert = false
    @State private var resetSuccess = false
    @State private var email: String = ""
    @State private var showingResetAlert = false
    @State private var errorMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var loginButtonColor: Color {
        return !credentialFieldsAreEmpty ? Color(hex: 0xF75E68) : Color(UIColor.lightGray)
    }
    
    var credentialFieldsAreEmpty: Bool {
        return (email.isEmpty)
    }
    
    var body: some View {
        VStack {
            
            Image("CashFlowLogo")
                .padding(.top, 40)
            
            Text("Olvidé mi contraseña")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            
            TextField("Correo electrónico", text: $email)
                .keyboardType(.emailAddress)
                .padding(.top, 20)
                .autocapitalization(.none)
            
            Button(action: {
                resetPassword()
            }) {
                Text("Restablecer contraseña")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2))
            }
            .disabled(credentialFieldsAreEmpty)
            .background(loginButtonColor)
            .cornerRadius(10)
            .padding(.top, 40)
        }
        .padding(40)
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Confirmar Restablecimiento"),
                message: Text("Se envió un correo con un link para restablecer su contraseña"),
                primaryButton: .destructive(Text("Ingresar")) {
                    dismiss()
                    coordinator.currentRoute = .login
                },
                secondaryButton: .cancel()
            )
        }
        .alert(isPresented: $showingResetAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("Aceptar"))
            )
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                showingResetAlert = true
                return
            } else {
                showConfirmationAlert = true
            }
        }
    }
}
