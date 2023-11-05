//
//  UpdateUser.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

protocol UpdateUser {
    func execute(
        uuid: String,
        user: UserRequestDTO,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultUpdateUser: UpdateUser {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(
        uuid: String,
        user: UserRequestDTO,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return userRepository.updateUser(uuid: uuid, user: user, completion: completion)
    }
}
