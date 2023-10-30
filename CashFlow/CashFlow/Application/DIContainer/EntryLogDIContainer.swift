//
//  EntryLogDIContainer.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/10/23.
//

import Foundation

class EntryLogDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeVisualizeExpenseHistory() -> VisualizeExpenseHistory {
        VisualizeExpenseHistory(expenseRepository: makeExpenseRepository())
    }
    
    func makeViewExpense() -> ViewExpense {
        ViewExpense(expenseRepository: makeExpenseRepository())
    }
    
    func makeVisualizeIncomeHistory() -> VisualizeIncomeHistory {
        VisualizeIncomeHistory(incomeRepository: makeIncomeRepository())
    }
    
    func makeViewIncome() -> ViewIncome {
        ViewIncome(incomeRepository: makeIncomeRepository())
    }
    
    func makeEnterIncome() -> DefaultEnterIncome {
        DefaultEnterIncome(incomeRepository: makeIncomeRepository())
    }
    
    // MARK: - Repositories
    func makeExpenseRepository() -> ExpenseRepository {
        DefaultExpenseRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeIncomeRepository() -> IncomeRepository {
        DefaultIncomeRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    // MARK: - Entry History
    @MainActor func makeExpenseHistoryViewModel(sharedData: SharedData) -> ExpenseHistoryView.ExpenseHistoryViewModel {
        ExpenseHistoryView.ExpenseHistoryViewModel(
            sharedData: sharedData,
            visualizeExpenseHistory: makeVisualizeExpenseHistory(),
            viewExpense: makeViewExpense()
        )
    }
    
    @MainActor func makeIncomeHistoryViewModel(sharedData: SharedData) -> IncomeHistoryView.IncomeHistoryViewModel {
        IncomeHistoryView.IncomeHistoryViewModel(
            sharedData: sharedData,
            visualizeIncomeHistory: makeVisualizeIncomeHistory(),
            viewIncome: makeViewIncome(),
            enterIncome: makeEnterIncome()
        )
    }
    
        
}
