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
    
    func createIncomeEntry() -> Income {
        // TODO: Implement
        return Income.sampleData[0]
    }
    
    func updateIncomeEntry() -> Bool {
        // TODO: Implement
        return true
    }
    
    func deleteIncomeEntry() {
        // TODO: Implement
    }
    
    public func getAllIncomeEntries(
        completion: @escaping (Result<[Income], Error>) -> Void
    ) -> Cancellable? {
        // let requestDTO = IncomeRequestDTO(query: query)
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getAllIncomeEntries()
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
