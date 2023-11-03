//
//  EntryHistoryViewModel.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/10/23.
//

import Foundation

extension IncomeHistoryView {
    @MainActor class IncomeHistoryViewModel: ObservableObject {
        
        // MARK: - Use Cases
        private let visualizeIncomeHistory: VisualizeIncomeHistory
        private let viewIncome: ViewIncome
        private let enterIncome: DefaultEnterIncome
        private let editIncome: EditIncome
        private let deleteIncome: DeleteIncome
        
        private let sharedData: SharedData
        //@Published var incomeHistory: [Income] = Income.sampleData
        @Published var incomeHistory: [Income] = []
        
        private var incomeLoadTask: Cancellable? { willSet { incomeLoadTask?.cancel() } }
        private var incomePostTask: Cancellable? { willSet { incomePostTask?.cancel() } }
        private var incomePutTask: Cancellable? { willSet { incomePutTask?.cancel() } }
        
        init(
            sharedData: SharedData,
            visualizeIncomeHistory: VisualizeIncomeHistory,
            viewIncome: ViewIncome,
            enterIncome: DefaultEnterIncome,
            editIncome: EditIncome,
            deleteIncome: DeleteIncome
        ) {
            self.sharedData = sharedData
            self.visualizeIncomeHistory = visualizeIncomeHistory
            self.viewIncome = viewIncome
            self.enterIncome = enterIncome
            self.editIncome = editIncome
            self.deleteIncome = deleteIncome
            
            
            self.deleteIncomeEntry(incomeID: "7d75171f-6f7f-452b-a14b-631543e39ed5")
            
            self.loadIncomeEntries()
            // TODO: Change the following UUID to an actual UUID present in Income database table.
            // self.loadIncomeByID(incomeID: "2572d43a-721f-11ee-b962-0242ac120002")
            //self.createIncomeEntry(incomeEntry: Income(id: UUID(), total: 2500000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 17)).date!, description: "Ingreso de prueba desde el ViewModel", category: .otros))
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
        
        func createIncomeEntry(incomeEntry: Income) {
            incomePostTask = enterIncome.execute(incomeEntry: incomeEntry) { result in
                switch result {
                case .success:
                    print("Successfully created income entry.")
                case .failure:
                    print("Failed posting entry.")
                }
            }
        }
        
        func updateIncomeEntry(incomeEntry: Income) {
            incomePutTask = editIncome.execute(incomeEntry: incomeEntry) { result in
                switch result {
                case .success:
                    print("Successfully updated income entry.")
                case .failure:
                    print("Failed updating entry.")
                }
            }
        }
        
        func deleteIncomeEntry(incomeID: String) {
            incomePutTask = deleteIncome.execute(incomeID: incomeID) { result in
                switch result {
                case .success:
                    print("Successfully deleted income entry.")
                case .failure:
                    print("Failed deleting entry.")
                }
            }
        }
    }
}

extension ExpenseHistoryView {
    @MainActor class ExpenseHistoryViewModel: ObservableObject {
        
        // MARK: - Use Cases
        private let visualizeExpenseHistory: VisualizeExpenseHistory
        private let viewExpense: ViewExpense
        
        //@Published var expenseHistory: [Expense] = Expense.sampleData
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
            //self.loadExpenseByID(expenseID: "77fbd880-71ea-11ee-b962-0242ac120002")
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
    }
}
