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
        
        // TODO: Implement correctly
        
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
    
    func createExpenseEntry() -> Expense {
        // TODO: Implement
        return Expense.sampleData[0]
    }
    
    func updateExpenseEntry() -> Bool {
        // TODO: Implement
        return true
    }
    
    func deleteExpenseEntry() {
        // TODO: Implement
    }
    
    public func getAllExpenseEntries(
        completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable? {
        // let requestDTO = ExpenseRequestDTO(query: query)
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getAllExpenseEntries()
        task.networkTask = self.dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                //self.cache.save(response: responseDTO, for: requestDTO)
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
}
