//
//  ExpenseResponseDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

// MARK: - Data Transfer Object

struct ExpenseResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        // Si lo que se quiere viene con un key distinto, se hace lo siguiente
        // case movies = "results"
        // TODO: Ver qué se está devolviendo (JSON)
        case expenses
    }
    
    let expenses: [ExpenseDTO]
    
    // La estructura 'ExpenseResponseDTO' *puede* venir como un conjunto de objetos JSON Expense.
    // Estos últimos se definen en la siguiente estructura.
    struct ExpenseDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case total
            case date
            case description
            case vendorName
            case category
            case ocrText
        }
        
        let id: UUID
        let total: Int
        let date: Date
        let description: String?
        let vendorName: String?
        let category: ExpenseCategory.RawValue
        let ocrText: String?
    }
}

// TODO: ¿Cómo se hace el mappeo cuando la respuesta es una lista (JSON) de Expenses?

extension ExpenseResponseDTO {
    func toDomain() -> [Expense] {
        var expenseArray: [Expense] = []
        for expense in expenses {
            // TODO: Revisar con qué formato se devuelve el campo 'date'.
            var temp = Expense(id: expense.id, total: expense.total, date: expense.date , category: ExpenseCategory(rawValue: expense.category) ?? ExpenseCategory.otros)
            expenseArray.append(temp)
        }
        return expenseArray
    }
}

extension ExpenseResponseDTO.ExpenseDTO {
    func toDomain() -> Expense {
        return .init(id: id,
                     total: total,
                     date: date,
                     description: description,
                     vendorName: vendorName,
                     category: ExpenseCategory(rawValue: category) ?? ExpenseCategory.otros,
                     ocrText: ocrText)
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
