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
        private let viewIncome: ViewIncome
        private let enterIncome: DefaultEnterIncome
        private let sharedData: SharedData
        private let deleteIncome: DeleteIncome
        @Published var incomeHistory: [Income] = []
        
        private var incomeLoadTask: Cancellable? { willSet { incomeLoadTask?.cancel() } }
        private var incomePostTask: Cancellable? { willSet { incomePostTask?.cancel() } }
        private var incomePutTask: Cancellable? { willSet { incomePutTask?.cancel() } }
        private let updateIncome: DefaultUpdateIncome
        
        init(
            sharedData: SharedData,
            visualizeIncomeHistory: VisualizeIncomeHistory,
            viewIncome: ViewIncome,
            enterIncome: DefaultEnterIncome,
            updateIncome: DefaultUpdateIncome,
            deleteIncome: DeleteIncome
        ) {
            self.sharedData = sharedData
            self.visualizeIncomeHistory = visualizeIncomeHistory
            self.viewIncome = viewIncome
            self.enterIncome = enterIncome
            self.updateIncome = updateIncome
            self.deleteIncome = deleteIncome
        }
        
        func updateIncomeEntry(incomeID: String, updatedIncome: Income, completion: @escaping (Bool) -> Void) {
            
            let startDate = Date()
            
            incomePostTask = updateIncome.execute(incomeID: incomeID, updatedIncome: updatedIncome, userID: sharedData.userId) { result in
                switch result {
                case .success:
                    print("Income updated successfully.")
                    
                    // TIMER
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("El caso de uso 'updateIncomeEntry' tomó " + executionTime.description + " en ejecutarse.")
                    
                    completion(true)
                case .failure:
                    print("Failed updating income.")
                    completion(false)
                }
            }
        }
        
        func loadIncomeEntries(completion: @escaping () -> Void) {
            
            let startDate = Date()
            
            incomeLoadTask = visualizeIncomeHistory.execute(userID: sharedData.userId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let incomeHistory):
                        self.sharedData.incomeHistory = incomeHistory
                        self.sharedData.dataIncomeLoaded = true
                        
                        // TIMER
                        let executionTime = Date().timeIntervalSince(startDate)
                        print("El caso de uso 'loadIncomeEntries' tomó " + executionTime.description + " en ejecutarse.")
                        
                        completion()
                    case .failure:
                        print("Failed loading income entries.")
                    }
                }
            }
        }
        
        func loadIncomeByID(incomeID: String) {
            
            let startDate = Date()
            
            incomeLoadTask = viewIncome.execute(incomeID: incomeID, userID: sharedData.userId) { [weak self] result in
                switch result {
                case .success(let entry):
                    
                    self?.sharedData.incomeHistory.append(entry)
                    self?.sharedData.dataIncomeLoaded = true
                    
                    // TIMER
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("El caso de uso 'loadIncomeByID' tomó " + executionTime.description + " en ejecutarse.")
                    
                case .failure:
                    print("Failed loading entry.")
                }
            }
        }
        
        func deleteIncomeEntry(incomeID: String, completion: @escaping (Bool) -> Void) {
            
            let startDate = Date()
            
            incomePutTask = deleteIncome.execute(id: incomeID, userID: sharedData.userId) { result in
                switch result {
                case .success:
                    print("Successfully deleted income entry.")
                    
                    // TIMER
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("El caso de uso 'deleteIncomeEntry' tomó " + executionTime.description + " en ejecutarse.")
                    
                    completion(true)
                case .failure:
                    print("Failed deleting entry.")
                    completion(false)
                }
            }
        }
        
        func createIncomeEntry(incomeEntry: Income, completion: @escaping (Bool) -> Void) {
            
            let startDate = Date()
            
            incomePostTask = enterIncome.execute(userID: sharedData.userId, incomeEntry: incomeEntry) { result in
                switch result {
                case .success:
                    print("Success")
                    self.loadIncomeEntries {
                        
                        // TIMER
                        let executionTime = Date().timeIntervalSince(startDate)
                        print("El caso de uso 'createIncomeEntry' tomó " + executionTime.description + " en ejecutarse.")
                        
                        completion(true)
                    }
                case .failure:
                    print("Failed posting entry.")
                    completion(false)
                }
            }
        }
    }
}

extension ExpenseHistoryView {
    @MainActor class ExpenseHistoryViewModel: ObservableObject {
        
        private let visualizeExpenseHistory: VisualizeExpenseHistory
        private let viewExpense: ViewExpense
        private let enterExpense: DefaultEnterExpense
        @Published var expenseHistory: [Expense] = []
        private let sharedData: SharedData
        private let updateExpense: DefaultUpdateExpense
        private var expensesLoadTask: Cancellable? { willSet { expensesLoadTask?.cancel() } }
        private var expensePostTask: Cancellable? { willSet { expensePostTask?.cancel() } }
        private var expenseDeleteTask: Cancellable? { willSet { expenseDeleteTask?.cancel() } }
        private let deleteExpense: DeleteExpense
        
        init(
            sharedData: SharedData,
            visualizeExpenseHistory: VisualizeExpenseHistory,
            viewExpense: ViewExpense,
            updateExpense: DefaultUpdateExpense,
            enterExpense: DefaultEnterExpense,
            deleteExpense: DeleteExpense
        ) {
            self.sharedData = sharedData
            self.visualizeExpenseHistory = visualizeExpenseHistory
            self.viewExpense = viewExpense
            self.updateExpense = updateExpense
            self.enterExpense = enterExpense
            self.deleteExpense = deleteExpense
        }
        
        func updateExpenseEntry(expenseID: String, updatedExpense: Expense, completion: @escaping (Bool) -> Void) {
            
            let startDate = Date()
            
            expensePostTask = updateExpense.execute(expenseID: expenseID, updatedExpense: updatedExpense, userID: sharedData.userId) { result in
                switch result {
                case .success:
                    print("Expense updated successfully.")
                    
                    // TIMER
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("El caso de uso 'updateExpenseEntry' tomó " + executionTime.description + " en ejecutarse.")
                    
                    completion(true)
                case .failure:
                    print("Failed updating expense.")
                    completion(false)
                }
            }
        }
        
        func loadExpenses(completion: @escaping () -> Void) {
            
            let startDate = Date()
            
            expensesLoadTask = visualizeExpenseHistory.execute(userID: sharedData.userId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let expenseHistory):
                        self.sharedData.expenseHistory = expenseHistory
                        self.sharedData.dataExpenseLoaded = true
                        
                        // TIMER
                        let executionTime = Date().timeIntervalSince(startDate)
                        print("El caso de uso 'loadExpenses' tomó " + executionTime.description + " en ejecutarse.")
                        
                        completion()
                    case .failure:
                        print("Failed loading expense entries.")
                    }
                }
            }
        }
        
        func loadExpenseByID(expenseID: String) {
            
            let startDate = Date()
            
            expensesLoadTask = viewExpense.execute(expenseID: expenseID, userID: sharedData.userId) { [weak self] result in
                switch result {
                case .success(let expense):
                    
                    // TIMER
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("El caso de uso 'loadExpenseByID' tomó " + executionTime.description + " en ejecutarse.")
                    
                    self?.sharedData.expenseHistory.append(expense)
                case .failure:
                    print("Failed loading entry.")
                }
            }
        }
        
        func createExpenseEntry(expenseEntry: Expense, completion: @escaping (Bool) -> Void) {
            
            let startDate = Date()
            
            expensePostTask = enterExpense.execute(userID: sharedData.userId, expenseEntry: expenseEntry) { result in
                switch result {
                case .success:
                    print("Successfully creating entry")
                    self.loadExpenses {
                        
                        // TIMER
                        let executionTime = Date().timeIntervalSince(startDate)
                        print("El caso de uso 'createExpenseEntry' tomó " + executionTime.description + " en ejecutarse.")
                        
                        completion(true)
                    }
                case .failure:
                    print("Failed posting entry.")
                    completion(false)
                }
            }
        }
        
        func deleteExpenseEntry(expenseID: String, completion: @escaping (Bool) -> Void) {
            
            let startDate = Date()
            
            expenseDeleteTask = deleteExpense.execute(id: expenseID, userID: sharedData.userId) { result in
                switch result {
                case .success:
                    print("Successfully deleted expense entry.")
                    
                    // TIMER
                    let executionTime = Date().timeIntervalSince(startDate)
                    print("El caso de uso 'deleteExpenseEntry' tomó " + executionTime.description + " en ejecutarse.")
                    
                    completion(true)
                case .failure:
                    print("Failed deleting entry.")
                    completion(false)
                }
            }
        }
    }
}
