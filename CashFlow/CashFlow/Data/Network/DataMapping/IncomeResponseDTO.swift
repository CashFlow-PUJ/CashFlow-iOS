//
//  IncomeResponseDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/10/23.
//

import Foundation

struct IncomeResponseDTO: Decodable {
    /*
    private enum CodingKeys: String, CodingKey {
        // Si lo que se quiere viene con un key distinto, se hace lo siguiente
        // case movies = "results"
        // TODO: Ver qué se está devolviendo (JSON)
        case expenses
    }
    */
    
    let incomeEntries: [IncomeDTO]
    
    // La estructura 'ExpenseResponseDTO' *puede* venir como un conjunto de objetos JSON Expense.
    // Estos últimos se definen en la siguiente estructura.
    struct IncomeDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case total
            case date
            case description
            case category
        }
        
        let id: UUID
        let total: Int
        let date: Date
        let description: String
        let category: String
    }
}

// TODO: ¿Cómo se hace el mappeo cuando la respuesta es una lista (JSON) de Expenses?

extension IncomeResponseDTO {
    func toDomain() -> [Income] {
        var incomeArray: [Income] = []
        for entry in incomeEntries {
            // TODO: Revisar con qué formato se devuelve el campo 'date'.
            let temp = Income(id: entry.id, total: entry.total, date: entry.date, description: entry.description, category: IncomeCategory(rawValue: entry.category) ?? IncomeCategory.otros)
            incomeArray.append(temp)
        }
        print("Income Array: ", incomeArray)
        return incomeArray
    }
}

extension IncomeResponseDTO.IncomeDTO {
    func toDomain() -> Income {
        return .init(
            id: id,
            total: total,
            date: date,
            description: description,
            category: IncomeCategory(rawValue: category) ?? IncomeCategory.otros)
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
