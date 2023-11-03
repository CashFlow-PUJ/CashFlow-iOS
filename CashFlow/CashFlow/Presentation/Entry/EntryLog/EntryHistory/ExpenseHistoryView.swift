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
    @EnvironmentObject var sharedData: SharedData
    @State var selectedEntry: Expense?
    
    var body: some View {
        if (categoryFilter == .total) {
            List(sharedData.expenseHistory) { entry in
                ExpenseHistoryRow(entry: entry, selectedEntry: $selectedEntry, viewModel: viewModel)
            }
            .listStyle(.inset)
        }
        else {
            List(sharedData.expenseHistory.filter({$0.category == categoryFilter})) { entry in
                ExpenseHistoryRow(entry: entry, selectedEntry: $selectedEntry, viewModel: viewModel)
            }
            .listStyle(.inset)
        }
    }
}
