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

extension ExpenseHistoryView {
    @MainActor class ExpenseHistoryViewModel: ObservableObject {
        
        private let visualizeExpenseHistory: VisualizeExpenseHistory
        private let viewExpense: ViewExpense
        
        //@Published var expenseHistory: [Expense] = Expense.sampleData
        @Published var expenseHistory: [Expense] = []
        
        private var expensesLoadTask: Cancellable? { willSet { expensesLoadTask?.cancel() } }
        
        init(
            visualizeExpenseHistory: VisualizeExpenseHistory,
            viewExpense: ViewExpense
        ) {
            self.visualizeExpenseHistory = visualizeExpenseHistory
            self.viewExpense = viewExpense
            //self.loadExpenses()
            self.loadExpenseByID(expenseID: "77fbd880-71ea-11ee-b962-0242ac120002")
        }
        
        func loadExpenses(){
            expensesLoadTask = visualizeExpenseHistory.execute() { [weak self] result in
                switch result {
                case .success(let expenseHistory):
                    
                    // DEBUG PRINT
                    print("EXPENSE HISTORY: ", expenseHistory)
                    
                    self?.expenseHistory = expenseHistory
                case .failure:
                    print("Failed loading expenses.")
                }
            }
        }
        
        func loadExpenseByID(expenseID: String) {
            expensesLoadTask = viewExpense.execute(expenseID: expenseID) { [weak self] result in
                switch result {
                case .success(let expense):
                    
                    // DEBUG PRINT
                    print("EXPENSE: ", expense)
                    
                    self?.expenseHistory.append(expense)
                case .failure:
                    print("Failed loading entry.")
                }
            }
        }
    }
}
