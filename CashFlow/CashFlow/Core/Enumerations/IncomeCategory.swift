//
//  IncomeCategory.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation
import SwiftUI

enum IncomeCategory: String, CaseIterable, Identifiable {
    
    // TODO: Definir más categorías de ingreso
    case total = "Total"
    case salario = "Salario"
    case otros = "Otros"
    
    var color: Color {
        switch self {
        case .total: return .green
        case .salario: return .blue
        case .otros: return .purple
        }
    }
    
    var symbol: String {
        switch self {
        case .total: return "dollarsign.circle.fill"
        case .salario: return "dollarsign.circle.fill"
        case .otros: return "pencil.and.outline"
        }
    }
    var id: String { self.rawValue }
}
