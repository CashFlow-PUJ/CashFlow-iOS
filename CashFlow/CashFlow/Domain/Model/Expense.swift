//
//  Expense.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

struct Expense: Entry {
    var id: UUID
    var total: Int
    var date: Date
    var description: String?
    var vendorName: String?
    var category: ExpenseCategory
    var ocrText: String?
}

extension Expense {
    static let sampleData = [
        Expense(id: UUID(), total: 123000, date: Date.now, description: "Mercado en El Éxito de la Cl. 80", vendorName: "Almacenes Éxito", category: .mercado),
        Expense(id: UUID(), total: 234000, date: Date.now, description: "Mercado en Carulla de la Cl. 85", vendorName: "Carulla", category: .mercado),
    ]
}
