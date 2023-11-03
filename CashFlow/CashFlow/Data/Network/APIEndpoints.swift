//
//  APIEndpoints.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

struct APIEndpoints {
    
    // MARK: - Expenses
    
    static func getAllExpenseEntries() -> Endpoint<[ExpenseDTO]> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            //path: "user/GET/EXPENSES/\(userID)",
            path: "user/GET/EXPENSES/4gO09bQ47MaszLrTZCLUT1CQmPL2",
            //path: "expenses",
            method: .get
        )
    }
    
    static func getExpenseByID(id: String) -> Endpoint<ExpenseDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "expense/GET/\(id)",
            method: .get
        )
    }
    
    static func deleteExpense(expenseID: String) -> Endpoint<Void> {
        return Endpoint(
            path: "expense/DELETE/\(expenseID)",
            method: .delete
        )
    }
    
    // MARK: - Income
    
    static func getAllIncomeEntries() -> Endpoint<[IncomeDTO]> {
    //static func getAllIncomeEntries() -> Endpoint<String> {
        return Endpoint(
            // TODO: variable (parameter) for userID
            //path: "user/GET/INCOME/\(userID)",
            path: "user/GET/INCOME/4gO09bQ47MaszLrTZCLUT1CQmPL2",
            //path: "income",
            method: .get
        )
    }
    
    static func getIncomeByID(id: String) -> Endpoint<IncomeDTO> {
        return Endpoint(
            path: "income/GET/\(id)",
            method: .get
        )
    }
    
    static func postIncomeEntry(userID: String, with incomes: IncomeRequestDTO) -> Endpoint<Void> {
        return Endpoint(
            path: "user/POST/INCOME/\(userID)",
            method: .post,
            bodyParametersEncodable: incomes
        )
    }
    
    static func putIncomeEntry(incomeID: String, with incomes: IncomeRequestDTO) -> Endpoint<Void> {
        return Endpoint(
            path: "income/UPDATE/\(incomeID)",
            method: .put,
            bodyParametersEncodable: incomes
        )
    }
    
    static func deleteIncomeEntry(incomeID: String) -> Endpoint<Void> {
        return Endpoint(
            path: "income/DELETE/\(incomeID)",
            method: .delete
        )
    }
}
