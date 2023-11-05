//
//  APIEndpoints.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

struct APIEndpoints {
    
    // MARK: - Expenses
    
    static func getAllExpenseEntries(userID: String) -> Endpoint<[ExpenseDTO]> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "user/GET/EXPENSES",
            method: .get,
            additionalHeaders: ["Authorization": "Bearer \(userID)"]
        )
    }
    
    static func getExpenseByID(id: String) -> Endpoint<ExpenseDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "expense/GET/\(id)",
            method: .get
        )
    }
    
    // MARK: - Income
    
    static func getAllIncomeEntries(userID: String) -> Endpoint<[IncomeDTO]> {
        return Endpoint(
            // TODO: variable (parameter) for userID
            path: "user/GET/INCOME",
            method: .get,
            additionalHeaders: ["Authorization": "Bearer \(userID)"]
        )
    }
    
    static func getIncomeByID(id: String) -> Endpoint<IncomeDTO> {
        return Endpoint(
            // TODO: Update path to actual backend endpoint.
            path: "income/GET/\(id)",
            method: .get
        )
    }
    
    static func postIncomeEntry(userID: String, with incomes: IncomeRequestDTO) -> Endpoint<Void> {
        return Endpoint(
            path: "user/POST/INCOME",
            method: .post,
            additionalHeaders: ["Authorization": "Bearer \(userID)"],
            bodyParametersEncodable: incomes
        )
    }
    
    static func deleteIncomeEntry(incomeID: String, userID: String) -> Endpoint<Void> {
        return Endpoint(
            path: "income/DELETE/\(incomeID)",
            method: .delete,
            additionalHeaders: ["Authorization": "Bearer \(userID)"]
        )
    }
    
    static func postExpenseEntry(userID: String, with expenses: ExpenseRequestDTO) -> Endpoint<Void> {
        return Endpoint(
            path: "user/POST/EXPENSES",
            method: .post,
            additionalHeaders: ["Authorization": "Bearer \(userID)"],
            bodyParametersEncodable: expenses
        )
    }
    
    static func updateIncomeEntry(incomeID: String, with income: IncomeRequestDTO, userID: String) -> Endpoint<Void> {
        return Endpoint(
            path: "income/UPDATE/\(incomeID)",
            method: .put,
            additionalHeaders: ["Authorization": "Bearer \(userID)"],
            bodyParametersEncodable: income
        )
    }
    
    static func updateExpenseEntry(expenseID: String, with expense: ExpenseRequestDTO, userID: String) -> Endpoint<Void> {
        return Endpoint(
            path: "expense/UPDATE/\(expenseID)",
            method: .put,
            additionalHeaders: ["Authorization": "Bearer \(userID)"],
            bodyParametersEncodable: expense
        )
    }
    
    static func deleteExpense(expenseID: String, userID: String) -> Endpoint<Void> {
        return Endpoint(
            path: "expense/DELETE/\(expenseID)",
            method: .delete,
            additionalHeaders: ["Authorization": "Bearer \(userID)"]
        )
    }
    
    static func getUserByUUID(uuid: String) -> Endpoint<UserDTO> {
        return Endpoint(
            path: "user/GET",
            method: .get,
            additionalHeaders: ["Authorization": "Bearer \(uuid)"]
        )
    }
    
    static func updateUser(userID: String, with user: UserRequestDTO) -> Endpoint<Void> {
        return Endpoint(
            path: "user/UPDATE",
            method: .put,
            additionalHeaders: ["Authorization": "Bearer \(userID)"],
            bodyParametersEncodable: user
        )
    }
}
