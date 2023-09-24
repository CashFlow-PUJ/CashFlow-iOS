//
//  TransactionHistory.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import Foundation

class TransactionHistory: ObservableObject {
    @Published var data: [Transaction]
    
    init(data: [Transaction]) {
        self.data = data
    }
}

extension TransactionHistory {
    static let sampleData: TransactionHistory  = TransactionHistory(data: [
        Transaction.sampleData[0],
        Transaction.sampleData[0],
        Transaction.sampleData[0],
        Transaction.sampleData[0]
    ])
}
