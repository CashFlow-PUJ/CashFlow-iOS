//
//  EntryHistoryViewModel.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/10/23.
//

import Foundation

extension IncomeHistoryView {
    @MainActor class IncomeHistoryViewModel: ObservableObject {
        private let visualizeIncomeHistory: VisualizeIncomeHistory
        
        @Published var incomeHistory: [Income] = Income.sampleData
        
        init(
            visualizeIncomeHistory: VisualizeIncomeHistory
        ) {
            self.visualizeIncomeHistory = visualizeIncomeHistory
        }
    }
}

//extension ExpenseHistoryView {
    @MainActor class ExpenseHistoryViewModel: ObservableObject {
        
        private let visualizeExpenseHistory: VisualizeExpenseHistory
        
        //@Published var expenseHistory: [Expense] = Expense.sampleData
        @Published var expenseHistory: [Expense] = []
        
        private var expensesLoadTask: Cancellable? { willSet { expensesLoadTask?.cancel() } }
        
        init(
            visualizeExpenseHistory: VisualizeExpenseHistory
        ) {
            self.visualizeExpenseHistory = visualizeExpenseHistory
            self.expenseHistory = self.loadExpenses()
        }
        
        func loadExpenses() -> [Expense] {
            expensesLoadTask = visualizeExpenseHistory.execute() { [weak self] result in
                switch result {
                case .success(let expenseHistory):
                    print(expenseHistory)
                    self?.expenseHistory = expenseHistory
                case .failure(let error):
                    print("Failed loading expenses")
                    //print(error.localizedDescription)
                }
            }
            return self.expenseHistory
        }
    }
//}
