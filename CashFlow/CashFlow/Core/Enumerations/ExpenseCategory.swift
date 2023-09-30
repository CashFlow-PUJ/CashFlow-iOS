//
//  ExpenseCategory.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation
import SwiftUI

enum ExpenseCategory: String, CaseIterable, Identifiable {
    
    // TODO: Definir más categorías de gasto
    case total = "Total"
    case transporte = "Transporte"
    case tecnologia = "Tecnología"
    case vestuario = "Vestuario"
    case servicios = "Servicios"
    case mercado = "Mercado"
    case salud = "Salud"
    case otros = "Otros"
    case ocio = "Ocio"

    var color: Color {
        switch self {
        case .total: return .red
        case .transporte: return .blue
        case .tecnologia: return .purple
        case .vestuario: return .green
        case .servicios: return .orange
        case .mercado: return .cyan
        case .salud: return .pink
        case .otros: return .gray
        case .ocio: return .yellow
        }
    }
    
    var symbol: String {
        switch self {
        case .total: return "dollarsign.circle.fill"
        case .transporte: return "car.fill"
        case .tecnologia: return "laptopcomputer"
        case .vestuario: return "star"
        case .servicios: return "lightbulb.led.fill"
        case .mercado: return "cart.fill"
        case .salud: return "stethoscope"
        case .otros: return "pencil.and.outline"
        case .ocio: return "figure.play"
        }
    }
    
    var id: String { self.rawValue }
    
}
