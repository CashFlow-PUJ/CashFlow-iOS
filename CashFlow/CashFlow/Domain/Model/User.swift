//
//  User.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 1/10/23.
//

import Foundation

struct User: Identifiable {
    var id: UUID
    var total: Int
    var date: Date
    var description: String
    var category: IncomeCategory
}
