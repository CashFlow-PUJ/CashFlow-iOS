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
    static var sampleData = [
        Income(id: UUID(), total: 8000000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 1)).date!, description: "Pago Nómina Indefinido", category: .salario),
    ]
}

