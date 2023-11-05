//
//  DefaultExpenseRepository.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

final class DefaultExpenseRepository: ExpenseRepository {
    
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
    
    func getExpenseEntryByID(
        expenseID: String,
        completion: @escaping (Result<Expense, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getExpenseByID(id: expenseID)
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
    
    func createExpenseEntry(
        userID: String,
        expenseEntry: Expense,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.postExpenseEntry(
            userID: userID,
            with: ExpenseRequestDTO.fromDomain(expenseEntry: expenseEntry)
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
    
    func updateExpenseEntry(
        expenseID: String,
        expenseEntry: Expense,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?  {
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.updateExpenseEntry(expenseID: expenseID, with: ExpenseRequestDTO.fromDomain(expenseEntry: expenseEntry))
        
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
    
    func deleteExpenseEntry(
            expenseID: String,
            completion: @escaping (Result<Void, Error>) -> Void
        ) -> Cancellable? {
            let task = RepositoryTask()
            let endpoint = APIEndpoints.deleteExpense(
                expenseID: expenseID
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
    
    public func getAllExpenseEntries(
        userID: String,
        completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable? {
        // let requestDTO = ExpenseRequestDTO(query: query)
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getAllExpenseEntries(userID: userID)
        task.networkTask = self.dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                //self.cache.save(response: responseDTO, for: requestDTO)
                var expenseArray: [Expense] = []
                for expenseEntry in responseDTO {
                    expenseArray.append(expenseEntry.toDomain())
                }
                completion(.success(expenseArray))
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
