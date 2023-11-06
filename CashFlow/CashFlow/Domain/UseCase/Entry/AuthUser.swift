//
//  AuthUser.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 6/11/23.
//

import Foundation

final class AuthUser {
    
    private let userRepository: UserRepository
    
    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    func execute(
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return userRepository.auth(
            userID: userID,
            completion: { result in completion(result) }
        )
    }
}
