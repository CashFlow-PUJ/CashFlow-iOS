//
//  AuthViewModel.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 5/09/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

enum FBError: Error, Identifiable {
    case error(String)
    
    var id: UUID {
        UUID()
    }
    
    var errorMessage: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}

class AuthViewModel: ObservableObject {
    
    // TODO: Perhaps this could be deleted. Test .errorMessage call either in LoginView or SignupView.
    @Published var errorMessage: String?
    
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, FBError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error.localizedDescription)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            }
            
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping (Result<Bool, FBError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error.localizedDescription)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            }
            
        }
    }
    
    func logIn(credential: AuthCredential, completion: @escaping (Result<Bool, FBError>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error.localizedDescription)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(true))
                }
                
                // TODO: SAVE USER OBJECT IN MEMORY
                /*
                self.email = result?.user.email
                self.photoURL = result?.user.photoURL!.absoluteString
                */
            }
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch _ {
            print("Error signing out.")
        }
    }
    
}
