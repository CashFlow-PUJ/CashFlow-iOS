//
//  ExpenseRequestDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

struct ExpenseRequestDTO: Encodable {
    let query: String
    let expenseID: String
}
