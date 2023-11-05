//
//  SharedData.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 29/10/23.
//

import Foundation

@MainActor
class SharedData: ObservableObject {
    @Published var incomeHistory: [Income] = []
    @Published var expenseHistory: [Expense] = []
    @Published var dataIncomeLoaded = false
    @Published var dataExpenseLoaded = false
    @Published var userId = ""
}
