//
//  ExpenseHistoryView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct ExpenseHistoryView: View {
    
    @Binding var categoryFilter: ExpenseCategory
    
    var entryHistory: [Expense] = Expense.sampleData
    
    // TODO: The ExpenseHistoryViewModel is being instantiated in the coordinator.appDIContainer, how do I access it?
    //private var viewModel: ExpenseHistoryViewModel
    
    //  @StateObject private var viewModel = ExpenseHistoryViewModel(visualizeExpenseHistory: VisualizeExpenseHistory(expenseRepository: DefaultExpenseRepository(dataTransferService: DefaultDataTransferService() as! DataTransferService) as ExpenseRepository))
    
    var body: some View {
        
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
        
    }
}
