//
//  IncomeHistoryView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI



struct IncomeHistoryView: View {
    
    //@EnvironmentObject var coordinator: Coordinator
    @Binding var categoryFilter: IncomeCategory
    @StateObject var viewModel: IncomeHistoryViewModel
    @EnvironmentObject var sharedData: SharedData
     
    @State var selectedEntry: Income?
    
    var body: some View {
        if (categoryFilter == .total) {
            List(sharedData.incomeHistory) { entry in
                IncomeHistoryRow(entry: entry, selectedEntry: $selectedEntry)
            }
            .listStyle(.inset)
        }
        else {
            List(sharedData.incomeHistory.filter({$0.category == categoryFilter})) { entry in
                IncomeHistoryRow(entry: entry, selectedEntry: $selectedEntry)
            }
            .listStyle(.inset)
        }
    }
}
