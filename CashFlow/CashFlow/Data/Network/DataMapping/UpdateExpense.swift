//
//  UpdateExpense.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 2/11/23.
//

import Foundation

protocol UpdateExpense {
    func execute(
        expenseID: String,
        updatedExpense: Expense,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultUpdateExpense: UpdateExpense {
    private let expenseRepository: ExpenseRepository
    
    init(expenseRepository: ExpenseRepository){
        self.expenseRepository = expenseRepository
    }
    
    func execute(
        expenseID: String,
        updatedExpense: Expense,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.updateExpenseEntry(expenseID: expenseID, expenseEntry: updatedExpense, userID: userID, completion: completion)
    }
}
