//
//  DeleteEntry.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 27/09/23.
//

import Foundation

protocol DeleteEntry {
    func execute(
        incomeID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class DeleteIncome: DeleteEntry {

    private let incomeRepository: IncomeRepository

    init(incomeRepository: IncomeRepository) {
        self.incomeRepository = incomeRepository
    }

    func execute(
        incomeID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return incomeRepository.deleteIncomeEntry(incomeID: incomeID, completion: completion)
    }
}
