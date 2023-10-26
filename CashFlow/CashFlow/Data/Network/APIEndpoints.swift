//
//  APIEndpoints.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

struct APIEndpoints {
    
    // MARK: - Expenses
    
    static func getAllExpenseEntries() -> Endpoint<ExpenseResponseDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            //path: "user/GET/EXPENSES/\(userID)",
            path: "user/GET/EXPENSES/GWnVlTjzOSNFYVkXlU6SafmwVe42",
            method: .get
        )
    }
    
    static func getExpenseByID(id: String) -> Endpoint<ExpenseResponseDTO.ExpenseDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "expense/GET/\(id)",
            method: .get
        )
    }
    
    // MARK: - Income
    
    static func getAllIncomeEntries() -> Endpoint<[IncomeDTO]> {
    //static func getAllIncomeEntries() -> Endpoint<String> {
        return Endpoint(
            // TODO: variable (parameter) for userID
            //path: "user/GET/INCOME/\(userID)",
            //path: "user/GET/INCOME/GWnVlTjzOSNFYVkXlU6SafmwVe42",
            path: "income",
            method: .get
        )
    }
    
    static func getIncomeByID(id: String) -> Endpoint<IncomeDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "income/GET/\(id)",
            method: .get
        )
    }
    
    static func postIncomeEntry(userID: String, with incomeRequestDTO: [IncomeRequestDTO]) -> Endpoint<Void> {
        return Endpoint(
            path: "user/POST/INCOME/\(userID)",
            method: .post
        )
    }
}
