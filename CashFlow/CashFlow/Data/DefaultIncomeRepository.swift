//
//  DefaultIncomeRepository.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/10/23.
//

import Foundation

final class DefaultIncomeRepository: IncomeRepository {
    
    private let dataTransferService: DataTransferService
    // TODO: Implement a cache (?)
    // private let cache: MoviesResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    )
    {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
    
    func getIncomeEntryByID(
        incomeID: String,
        userID: String,
        completion: @escaping (Result<Income, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getIncomeByID(id: incomeID)
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
    
    func createIncomeEntry(
        userID: String,
        incomeEntry: Income,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.postIncomeEntry(
            userID: userID,
            with: IncomeRequestDTO.fromDomain(incomeEntry: incomeEntry)
        )
        task.networkTask = self.dataTransferService.request(
            with: endpoint
        ) { resultado in
            switch resultado
            {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    func updateIncomeEntry(
        incomeID: String,
        incomeEntry: Income,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.updateIncomeEntry(incomeID: incomeID, with: IncomeRequestDTO.fromDomain(incomeEntry: incomeEntry), userID: userID)
        
        task.networkTask = self.dataTransferService.request(
            with: endpoint
        ) { resultado in
            switch resultado {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }

    
    func deleteIncomeEntry(
        incomeID: String,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?{
        let task = RepositoryTask()
        let endpoint = APIEndpoints.deleteIncomeEntry(
            incomeID: incomeID,
            userID: userID
        )
        task.networkTask = self.dataTransferService.request(
            with: endpoint
        ) { resultado in
            switch resultado
            {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    public func getAllIncomeEntries(
        userID: String,
        completion: @escaping (Result<[Income], Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getAllIncomeEntries(userID: userID)
        task.networkTask = self.dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                //self.cache.save(response: responseDTO, for: requestDTO)
                var incomeArray: [Income] = []
                for entry in responseDTO {
                    incomeArray.append(entry.toDomain())
                }
                completion(.success(incomeArray))
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
}
