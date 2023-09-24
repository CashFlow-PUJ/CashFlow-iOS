//
//  Transaction.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import Foundation

class Transaction: ObservableObject, Identifiable {
    
    // TODO: Create Category enumerate(s) (pueden ser dos: uno para transacciones de tipo ingreso y otra para gastos).
    var category: String
    var vendorName: String
    var transactionTotal: String
    
    init(category: String, vendorName: String, transactionTotal: String) {
        self.category = category
        self.vendorName = vendorName
        self.transactionTotal = transactionTotal
    }
}

extension Transaction {
    static let sampleData: [Transaction] = [
        Transaction(category: "Mercado", vendorName: "Almacenes Éxito", transactionTotal: "$123.000")
    ]
}
