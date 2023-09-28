//
//  ExpenseCategory.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

enum ExpenseCategory: String, CaseIterable, Identifiable {
    
    // TODO: Definir más categorías de gasto
    case mercado = "Mercado"
    case otros = "Otros"
    
    var id: String { self.rawValue }
    
}
