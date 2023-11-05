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
        userID: String,
        completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable?
    
    func getExpenseEntryByID(
        expenseID: String,
        userID: String,
        completion: @escaping (Result<Expense, Error>) -> Void
    ) -> Cancellable?
    
    func createExpenseEntry(
        userID: String,
        expenseEntry: Expense,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    func updateExpenseEntry(
        expenseID: String,
        expenseEntry: Expense,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    func deleteExpenseEntry(
        expenseID: String,
        userID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
}
