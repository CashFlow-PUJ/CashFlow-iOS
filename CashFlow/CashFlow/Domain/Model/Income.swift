//
//  Income.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

struct Income: Entry {
    var id: UUID
    var total: Double
    var date: Date
    var description: String
    var category: IncomeCategory
}
