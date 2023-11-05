//
//  UpdateIncome.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 2/11/23.
//

import Foundation

protocol UpdateIncome {
    func execute(
        incomeID: String,
        updatedIncome: Income,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultUpdateIncome: UpdateIncome {
    
    private let incomeRepository: IncomeRepository
    
    init(incomeRepository: IncomeRepository) {
        self.incomeRepository = incomeRepository
    }
    
    func execute(
        incomeID: String,
        updatedIncome: Income,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return incomeRepository.updateIncomeEntry(incomeID: incomeID, incomeEntry: updatedIncome, userID: userID, completion: completion)
    }
}

