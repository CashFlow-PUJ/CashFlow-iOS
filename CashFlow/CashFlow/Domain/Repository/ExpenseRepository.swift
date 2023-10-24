//
//  ExpenseRepository.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

protocol ExpenseRepository {
    
    @discardableResult
    func getAllExpenseEntries(
        completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable?
    
    func getExpenseEntryByID(
        expenseID: String,
        completion: @escaping (Result<Expense, Error>) -> Void
    ) -> Cancellable?
    
    func createExpenseEntry() -> Expense
    func updateExpenseEntry() -> Bool
    func deleteExpenseEntry()
}
