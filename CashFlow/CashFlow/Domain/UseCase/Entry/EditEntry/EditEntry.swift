//
//  EditEntry.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 27/09/23.
//

import Foundation

protocol EditEntry {
    func execute(
        incomeEntry: Income,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class EditIncome: EditEntry {
    
    private let incomeRepository: IncomeRepository
    
    init(incomeRepository: IncomeRepository) {
        self.incomeRepository = incomeRepository
    }
    
    func execute(
        incomeEntry: Income,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return incomeRepository.updateIncomeEntry(incomeEntry: incomeEntry, completion: completion)
    }
}

