//
//  Income.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

struct Income: Entry {
    var id: UUID
    var total: Int
    var date: Date
    var description: String
    var category: IncomeCategory
}

extension Income {
    static let sampleData = [
        Income(id: UUID(), total: 123000, date: Date.now, description: "Primera quincena Octubre :)", category: .salario),
        Income(id: UUID(), total: 123000, date: Date.now, description: "Segunda quincena Septiembre", category: .salario),
        Income(id: UUID(), total: 123000, date: Date.now, description: "Regalo de la abuela <3", category: .otros)
    ]
}
