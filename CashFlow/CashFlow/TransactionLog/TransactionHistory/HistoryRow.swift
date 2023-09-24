//
//  HistoryRow.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct HistoryRow: View {
    
    @ObservedObject var entry: Transaction
    
    var body: some View {
        Button(
            action: {},
            label: {
                HStack {
                    // TODO: Render different icon given the 'Category' enumerate value
                    Image(systemName: "cart.fill")
                        .renderingMode(.original)
                        .foregroundColor(.secondary)
                    Text(entry.vendorName)
                    Spacer()
                    Text(entry.transactionTotal)
                }.padding(.vertical, 10)
            }
        )
        .cornerRadius(10)
    }
}
