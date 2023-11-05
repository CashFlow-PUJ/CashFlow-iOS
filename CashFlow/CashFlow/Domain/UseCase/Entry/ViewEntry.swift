//
//  ViewEntry.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/10/23.
//

import Foundation

protocol ViewEntry {
    associatedtype Entry
    
    func execute(
        completion: @escaping (Result<Entry, Error>) -> Void
    ) -> Cancellable?
}

final class ViewExpense {
    
    private let expenseRepository: ExpenseRepository
    
    init(
        expenseRepository: ExpenseRepository
    ) {
        self.expenseRepository = expenseRepository
    }
    
    func execute(
        expenseID: String,
        completion: @escaping (Result<Expense, Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.getExpenseEntryByID(
            expenseID: expenseID,
            completion: { result in completion(result) }
        )
    }
}

final class ViewIncome {
    
    private let incomeRepository: IncomeRepository
    
    init(
        incomeRepository: IncomeRepository
    ) {
        self.incomeRepository = incomeRepository
    }
    
    func execute(
        incomeID: String,
        completion: @escaping (Result<Income, Error>) -> Void
    ) -> Cancellable? {
        return incomeRepository.getIncomeEntryByID(
            incomeID: incomeID,
            completion: { result in completion(result) }
        )
    }
}
