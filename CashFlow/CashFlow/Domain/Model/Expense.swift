//
//  Expense.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

struct Expense: Entry {
    var id: UUID
    var total: Int
    var date: Date
    var description: String?
    var vendorName: String?
    var category: ExpenseCategory
    var ocrText: String?
}

extension Expense {
    static var sampleData = [
        Expense(id: UUID(), total:  400000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day:  9)).date!, description: "Mercado en El Éxito de la Cl. 80", vendorName: "Almacenes Éxito", category: .mercado),
    ]
}

extension Expense {
    static func from(item: Item, vendor: String) -> Expense {
        // Aquí, crea un UUID para el id, ya que no viene de la API.
        let expenseId = UUID()
        
        // Establece la fecha actual para la fecha, ya que no viene de la API.
        let currentDate = Date()
        
        // Convierte la categoría string a tu enum, si aplicable. Maneja los casos no mapeados.
        let category = ExpenseCategory.matchCategory(from: item.category)

        // Crea y devuelve una instancia de Expense.
        return Expense(
            id: expenseId,
            total: item.price,
            date: currentDate,
            description: item.name,
            vendorName: vendor, // o cualquier otro valor adecuado
            category: category
        )
    }
}

extension ExpenseCategory {
    static func matchCategory(from string: String) -> ExpenseCategory {
        let lowercasedString = string.lowercased()
        
        for category in ExpenseCategory.allCases {
            if category.rawValue.lowercased() == lowercasedString {
                return category
            }
        }
        
        // Si no se encuentra ninguna coincidencia, se devuelve una categoría predeterminada.
        return .otros
    }
}
