//
//  IncomeHistoryView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct IncomeHistoryView: View {
    
    @Binding var categoryFilter: IncomeCategory
    
    var entryHistory: [Income] = Income.sampleData
    
    var body: some View {
        List(entryHistory.filter({$0.category == categoryFilter})) { entry in
            IncomeHistoryRow(entry: entry)
        }
        .listStyle(.inset)
    }
}
