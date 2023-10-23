//
//  APIEndpoints.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

struct APIEndpoints {
    
    static func getAllExpenseEntries() -> Endpoint<ExpenseResponseDTO> {
        return Endpoint(
            //path: "expense/GET",
            path: "expenses",
            method: .get
        )
    }
    
    static func getExpenseByID(id: String) -> Endpoint<ExpenseResponseDTO.ExpenseDTO> {
        return Endpoint(
            path: "expenses/\(id)",
            method: .get
        )
    }
}
