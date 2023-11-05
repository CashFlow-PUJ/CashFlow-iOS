//
//  EnterExpense.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 2/11/23.
//

import Foundation

protocol EntryExpense {
    func execute (
        userID: String,
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
        userID: String,
        expenseEntry: Expense,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.createExpenseEntry(userID: userID, expenseEntry: expenseEntry, completion: completion)
    }
}
