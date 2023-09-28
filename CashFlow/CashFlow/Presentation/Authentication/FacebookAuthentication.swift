//
//  FacebookAuthentication.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 21/09/23.
//

import Foundation
import FBSDKLoginKit

final class FacebookAuthentication {
    let loginManager = LoginManager()
    
    func loginFacebook(completionBlock: @escaping (Result<String, Error>) -> Void) {
        loginManager.logIn(permissions: ["email"], from: nil) { loginManagerLoginResult, error in
            if let error = error {
                print("Error login with Facebook \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            let token = loginManagerLoginResult?.token?.tokenString
            completionBlock(.success(token ?? "Empty Token"))
        }
        
    }
    
}
