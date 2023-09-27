//
//  Expense.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

struct Expense: Entry {
    var id: UUID
    var total: Double
    var date: Date
    var description: String
    var vendorName: String
    var category: ExpenseCategory
    var ocrText: String
}
