//
//  DeleteEntry.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 27/09/23.
//

import Foundation

protocol DeleteEntry {
    func execute(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class DeleteIncome: DeleteEntry {
    
    private let incomeRepository: IncomeRepository
    
    init(incomeRepository: IncomeRepository) {
        self.incomeRepository = incomeRepository
    }
    
    func execute(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return incomeRepository.deleteIncomeEntry(incomeID: id, completion: completion)
    }
}

final class DeleteExpense: DeleteEntry {
    
    private let expenseRepository: ExpenseRepository
    
    init(expenseRepository: ExpenseRepository) {
        self.expenseRepository = expenseRepository
    }
    
    func execute(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.deleteExpenseEntry(expenseID: id, completion: completion)
    }
}
