//
//  UserRepository.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

protocol UserRepository {
    
    @discardableResult
    func getUserByUUID(
        uuid: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable?

    @discardableResult
    func updateUser(
        uuid: String,
        user: UserRequestDTO,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    
    /*@discardableResult
    func deleteUser(
        uuid: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?

    /// Create a new user.
    @discardableResult
    func createUser(
        user: User,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?*/
}
