//
//  IncomeCategory.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

enum IncomeCategory: String, CaseIterable, Identifiable {
    
    // TODO: Definir más categorías de ingreso
    case salario = "Salario"
    case otros = "Otros"
    
    var id: String { self.rawValue }
}
