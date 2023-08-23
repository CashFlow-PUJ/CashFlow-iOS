//
//  LoginView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/08/23.
//

import SwiftUI

// TODO: Check best practice to place extensions in Swift (independent file, etc.)
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
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
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

                // Password Input
                SecureField("Contraseña", text: $password)
                    .padding(.vertical, 15)
                
                // Log in Button
                Button(action: {
                    print("\(email) \(password)")
                    // TODO: Authenticate
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
                
                NavigationLink {
                    // TODO: Forgot password View
                } label: {
                    Text("¿Olvidaste tu contraseña?")
                        .foregroundColor(Color(hex: 0xF75E68))
                }
                .padding(.top, 25)
                
                NavigationLink {
                    SignupView()
                } label: {
                    Text("¿No estás registrado?")
                        .foregroundColor(Color(hex: 0xF75E68))
                }
                .padding(.top, 10)
                
            }.padding(37)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}