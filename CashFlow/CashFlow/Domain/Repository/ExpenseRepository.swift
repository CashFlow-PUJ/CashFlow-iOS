//
//  ExpenseRepository.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

protocol ExpenseRepository {
    func getAllExpenseEntries(query: String,
                              completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable?
    func getExpenseEntryByID() -> Expense?
    func createExpenseEntry() -> Expense
    func updateExpenseEntry() -> Bool
    func deleteExpenseEntry()
}
