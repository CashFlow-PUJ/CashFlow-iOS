//
//  DefaultUserRepository.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

import Foundation

final class DefaultUserRepository: UserRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    public init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    }
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
    
    func getUserByUUID(
        uuid: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getUserByUUID(uuid: uuid)
        task.networkTask = self.dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                var errorString = "Error: "
                switch error {
                    case .resolvedNetworkFailure:
                        errorString += "\"Resolved Network failure\"."
                    case .parsing:
                        errorString += "Parsing error."
                    case .noResponse:
                        errorString += "No response."
                    case .networkFailure:
                        errorString += "Network failure."
                }
                print(errorString)
                completion(.failure(error))
            }
        }
        return task
    }
    
    func updateUser(
            uuid: String,
            user: UserRequestDTO,
            userID: String,
            completion: @escaping (Result<Void, Error>) -> Void
        ) -> Cancellable? {
            let task = RepositoryTask()
            let endpoint = APIEndpoints.updateUser(userID: userID, with: user, id: uuid)
            task.networkTask = self.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return task
        }
    
}
