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

    /// Update a user's information.
    /*@discardableResult
    func updateUser(
        uuid: String,
        user: User,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    
    /// Delete a user.
    @discardableResult
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
