//
//  SharedData.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 29/10/23.
//

import Foundation

class SharedData: ObservableObject {
    @Published var incomeHistory: [Income] = []
    @Published var expenseHistory: [Expense] = []
    @Published var dataLoaded = false
    
    func changeData () {
        if self.incomeHistory.isEmpty && self.expenseHistory.isEmpty {
            print("Esto no ha cambiado")
        } else {
            self.dataLoaded = true
        }
    }
}
