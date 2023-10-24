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
    @StateObject var viewModel: ExpenseHistoryViewModel
    
    var body: some View {
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
