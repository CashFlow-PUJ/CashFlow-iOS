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
        //@Published var incomeHistory: [Income] = Income.sampleData
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
            self.loadIncomeEntries()
            // TODO: Change the following UUID to an actual UUID present in Income database table.
            // self.loadIncomeByID(incomeID: "2572d43a-721f-11ee-b962-0242ac120002")
            //self.createIncomeEntry(incomeEntry: Income(id: UUID(), total: 2500000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 17)).date!, description: "Ingreso de prueba desde el ViewModel", category: .otros))
        }
        
        func updateIncomeEntry(incomeID: String, updatedIncome: Income) {
            incomePostTask = updateIncome.execute(incomeID: incomeID, updatedIncome: updatedIncome) { result in
                switch result {
                case .success:
                    print("Income updated successfully.")
                    self.loadIncomeEntries() // Recargar los ingresos después de la actualización
                case .failure:
                    print("Failed updating income.")
                }
            }
        }
        func loadIncomeEntries(){
            incomeLoadTask = visualizeIncomeHistory.execute() { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let incomeHistory):
                        print("INCOME: ", incomeHistory)
                        self.sharedData.incomeHistory = incomeHistory
                        self.sharedData.dataIncomeLoaded = true
                    case .failure:
                        print("Failed loading income entries.")
                    }
                }
            }
        }
        
        func loadIncomeByID(incomeID: String) {
            incomeLoadTask = viewIncome.execute(incomeID: incomeID) { [weak self] result in
                switch result {
                case .success(let entry):
                    
                    // DEBUG PRINT
                    //print("INCOME: ", entry)
                    
                    self?.sharedData.incomeHistory.append(entry)
                    self?.sharedData.dataIncomeLoaded = true
                case .failure:
                    print("Failed loading entry.")
                }
            }
        }
        
        func deleteIncomeEntry(incomeID: String) {
            incomePutTask = deleteIncome.execute(incomeID: incomeID) { result in
                switch result {
                case .success:
                    print("Successfully deleted income entry.")
                    self.loadIncomeEntries()
                case .failure:
                    print("Failed deleting entry.")
                }
            }
        }
        
        func createIncomeEntry(incomeEntry: Income) {
            incomePostTask = enterIncome.execute(incomeEntry: incomeEntry) { result in
                switch result {
                case .success:
                    print("Success")
                    self.loadIncomeEntries()
                case .failure:
                    print("Failed posting entry.")
                }
            }
        }
    }
}

extension ExpenseHistoryView {
    @MainActor class ExpenseHistoryViewModel: ObservableObject {
        
        private let visualizeExpenseHistory: VisualizeExpenseHistory
        private let viewExpense: ViewExpense
        
        @Published var expenseHistory: [Expense] = []
        private let sharedData: SharedData
        private var expensesLoadTask: Cancellable? { willSet { expensesLoadTask?.cancel() } }
        
        init(
            sharedData: SharedData,
            visualizeExpenseHistory: VisualizeExpenseHistory,
            viewExpense: ViewExpense
        ) {
            self.sharedData = sharedData
            self.visualizeExpenseHistory = visualizeExpenseHistory
            self.viewExpense = viewExpense
            self.loadExpenses()
        }
        
        func loadExpenses(){
            expensesLoadTask = visualizeExpenseHistory.execute() { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let expenseHistory):
                        print("EXPENSE: ", expenseHistory)
                        self.sharedData.expenseHistory = expenseHistory
                        self.sharedData.dataExpenseLoaded = true
                    case .failure:
                        print("Failed loading expense entries.")
                    }
                }
            }
        }
        
        func loadExpenseByID(expenseID: String) {
            expensesLoadTask = viewExpense.execute(expenseID: expenseID) { [weak self] result in
                switch result {
                case .success(let expense):
                    
                    // DEBUG PRINT
                    //print("EXPENSE: ", expense)
                    
                    self?.sharedData.expenseHistory.append(expense)
                case .failure:
                    print("Failed loading entry.")
                }
            }
        }
        
        func createExpenseEntry(expenseEntry: Expense){
            
        }
    }
}
