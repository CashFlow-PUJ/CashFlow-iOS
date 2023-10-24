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
            // TODO: Update path to actual backend endpoint.
            //path: "expense/GET",
            path: "expenses",
            method: .get
        )
    }
    
    static func getExpenseByID(id: String) -> Endpoint<ExpenseResponseDTO.ExpenseDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "expenses/\(id)",
            method: .get
        )
    }
    
    static func getAllIncomeEntries() -> Endpoint<IncomeResponseDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            //path: "income/GET",
            path: "income",
            method: .get
        )
    }
    
    static func getIncomeByID(id: String) -> Endpoint<IncomeResponseDTO.IncomeDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "income/\(id)",
            method: .get
        )
    }
}
