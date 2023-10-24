//
//  IncomeHistoryView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct IncomeHistoryView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @Binding var categoryFilter: IncomeCategory
    @StateObject var viewModel: IncomeHistoryViewModel
    
    var body: some View {
        if (categoryFilter == .total) {
            List(viewModel.incomeHistory) { entry in
                IncomeHistoryRow(entry: entry)
            }
            .listStyle(.inset)
        }
        else {
            List(viewModel.incomeHistory.filter({$0.category == categoryFilter})) { entry in
                IncomeHistoryRow(entry: entry)
            }
            .listStyle(.inset)
        }
    }
}
