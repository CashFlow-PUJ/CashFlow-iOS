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
    
    func getExpenseEntryByID() -> Expense? {
        // TODO: Implement
        return Expense.sampleData[0]
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
        //query: String,
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
                completion(.failure(error))
            }
        }
        return task
    }
}
