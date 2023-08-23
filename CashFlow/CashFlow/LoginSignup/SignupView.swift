//
//  SignupView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/08/23.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("Crea tu cuenta")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Email Input
                TextField("Correo electrónico", text: $email)
                    .keyboardType(.emailAddress)

                // Password Input
                SecureField("Contraseña", text: $password)
                
                // Log in Button
                Button(action: {
                    print("\(email) \(password)")
                }) {
                    Text("Continuar")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2))
                    // TODO: Authenticate
                }
                .background(Color(hex: 0xF75E68))
                .cornerRadius(8)
                
                // TODO: Policy Checkbox
                
                Button("¿Ya tienes una cuenta?"){
                    dismiss()
                }
                .foregroundColor(Color(hex: 0xF75E68))
                
                Spacer()
                Spacer()
                                
            }.padding(37)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
