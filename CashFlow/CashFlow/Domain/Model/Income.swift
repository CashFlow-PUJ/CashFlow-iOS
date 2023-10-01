//
//  Income.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation
import Combine

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
        Income(id: UUID(), total: 2500000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 11)).date!, description: "Pago Nómina Freelance", category: .salario),
        Income(id: UUID(), total: 3000000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 13)).date!, description: "Pago Nómina Freelance", category: .salario),
        Income(id: UUID(), total: 2500000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 17)).date!, description: "Regalo Cumpleaños", category: .otros),
    ]
}

