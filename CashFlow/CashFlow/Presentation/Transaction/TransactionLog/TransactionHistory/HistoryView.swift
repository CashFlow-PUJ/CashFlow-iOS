//
//  HistoryView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct HistoryView: View {
    
    // TODO: Fetch history data from database
    @ObservedObject var transactionHistory: TransactionHistory
    
    var body: some View {
        List (transactionHistory.data) { transaction in
            HistoryRow(entry: transaction)
        }
        .listStyle(.inset)
    }
}
