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
    
    var body: some View {
        List(entryHistory.filter({$0.category == categoryFilter})) { entry in
            ExpenseHistoryRow(entry: entry)
        }
        .listStyle(.inset)
    }
}
