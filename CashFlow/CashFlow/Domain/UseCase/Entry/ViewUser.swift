//
//  ViewUser.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

final class GetUserByUUID {
    
    private let userRepository: UserRepository
    
    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    func execute(
        uuid: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable? {
        return userRepository.getUserByUUID(
            uuid: uuid,
            completion: { result in completion(result) }
        )
    }
}
