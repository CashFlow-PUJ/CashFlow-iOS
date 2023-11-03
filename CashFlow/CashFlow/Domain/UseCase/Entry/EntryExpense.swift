//
//  EnterExpense.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 2/11/23.
//

import Foundation

protocol EntryExpense {
    func execute (
        expenseEntry: Expense,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultEnterExpense: EntryExpense {
    
    private let expenseRepository: ExpenseRepository
    
    init(expenseRepository: ExpenseRepository) {
        self.expenseRepository = expenseRepository
    }
    
    func execute(
        expenseEntry: Expense,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.createExpenseEntry(expenseEntry: expenseEntry, completion: completion)
    }
}
