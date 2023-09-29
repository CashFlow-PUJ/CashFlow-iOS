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
    static let sampleData = [
        Expense(id: UUID(), total:  400000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day:  9)).date!, description: "Mercado en El Éxito de la Cl. 80", vendorName: "Almacenes Éxito", category: .mercado),
        Expense(id: UUID(), total:  300000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day:  9)).date!, description: "Mercado en Carulla de la Cl. 85", vendorName: "Carulla", category: .mercado),
        Expense(id: UUID(), total:  300000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day:  9)).date!, description: "Pasaporte VIP Mundo Aventura", vendorName: "Mundo Aventura", category: .ocio),
        Expense(id: UUID(), total:  100000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10)).date!, description: "Pago Luz Enel Codensa", vendorName: "Enel Codensa", category: .servicios),
        Expense(id: UUID(), total:  200000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10)).date!, description: "Pago Agua Acueducto", vendorName: "Acueducto", category: .servicios),
        Expense(id: UUID(), total:  120000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10)).date!, description: "Pago Internet", vendorName: "ETB", category: .servicios),
        Expense(id: UUID(), total:  200000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10)).date!, description: "Pago Gas Vanti", vendorName: "Vanti", category: .servicios),
        Expense(id: UUID(), total:  600000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10)).date!, description: "Pago Telefonía Móvil", vendorName: "Wom", category: .servicios),
        Expense(id: UUID(), total: 4000000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 12)).date!, description: "Televisor en el Alkosto CC Edén", vendorName: "Alkosto", category: .tecnologia),
        Expense(id: UUID(), total: 1000000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 14)).date!, description: "Compra en el Dollarcity CC Tunal", vendorName: "Dollarcity", category: .otros),
        Expense(id: UUID(), total: 1000000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 15)).date!, description: "Compra en el Bershka CC Multiplaza", vendorName: "Bershka", category: .vestuario),
        Expense(id: UUID(), total:  500000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 16)).date!, description: "Compra en el Nike CC Multiplaza", vendorName: "Nike", category: .vestuario),
        Expense(id: UUID(), total: 1000000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 25)).date!, description: "Compra en el Pepeganga CC Multiplaza", vendorName: "Pepeganga", category: .otros),
        Expense(id: UUID(), total:  500000, date: (DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 26)).date!, description: "Compra en Dollarcity CC Edén", vendorName: "Dollarcity", category: .otros),
    ]
}
