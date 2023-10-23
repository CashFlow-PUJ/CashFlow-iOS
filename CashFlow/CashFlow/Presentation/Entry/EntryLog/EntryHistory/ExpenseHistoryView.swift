//
//  ExpenseHistoryView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct ExpenseHistoryView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @Binding var categoryFilter: ExpenseCategory
    
    //var entryHistory: [Expense] = Expense.sampleData
    
    // TODO: The ExpenseHistoryViewModel is being instantiated in the coordinator.appDIContainer, how do I access it?
    private var viewModel: ExpenseHistoryViewModel {
        return coordinator.appDIContainer.entryLogDIContainer.makeExpenseHistoryViewModel()
    }
    
    var body: some View {
        /*
        if (categoryFilter == .total) {
            List(entryHistory) { entry in
                ExpenseHistoryRow(entry: entry)
            }
            .listStyle(.inset)
        }
        else {
            List(entryHistory.filter({$0.category == categoryFilter})) { entry in
                ExpenseHistoryRow(entry: entry)
            }
            .listStyle(.inset)
        }
        */
        
        if (categoryFilter == .total) {
            List(viewModel.expenseHistory) { entry in
                ExpenseHistoryRow(entry: entry)
            }
            .listStyle(.inset)
        }
        else {
            List(viewModel.expenseHistory.filter({$0.category == categoryFilter})) { entry in
                ExpenseHistoryRow(entry: entry)
            }
            .listStyle(.inset)
        }
    }
}
