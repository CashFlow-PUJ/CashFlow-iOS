//
//  EntryHistoryViewModel.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/10/23.
//

import Foundation

class EntryHistoryViewModel: ObservableObject {
    private let visualizeExpenseHistory: VisualizeExpenseHistory
    private let visualizeIncomeHistory: VisualizeIncomeHistory
    
    // MARK: - OUTPUT
    // TODO: Initialize with empty arrays.
    var incomeHistory: [Income] = Income.sampleData
    var expenseHistory: [Expense] = Expense.sampleData
    
    private var expensesLoadTask: Cancellable? { willSet { expensesLoadTask?.cancel() } }
    
    init(
        visualizeExpenseHistory: VisualizeExpenseHistory,
        visualizeIncomeHistory: VisualizeIncomeHistory
    ) {
        self.visualizeExpenseHistory = visualizeExpenseHistory
        self.visualizeIncomeHistory = visualizeIncomeHistory
        //self.expenseHistory = self.loadExpenses()
    }
    
    func loadExpenses() -> [Expense] {
        expensesLoadTask = visualizeExpenseHistory.execute() { [weak self] result in
            switch result {
                case .success(let expenseHistory):
                    self?.expenseHistory = expenseHistory
                case .failure:
                    print("Failed loading expenses")
            }
        }
        return self.expenseHistory
    }
    
}
