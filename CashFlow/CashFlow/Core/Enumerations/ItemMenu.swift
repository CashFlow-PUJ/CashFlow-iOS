//
//  ItemMenu.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 1/10/23.
//

import Foundation

enum ItemMenu: String, CaseIterable, Identifiable {
    
    case dashboard = "Dashboard"
    //case rutas = "Rutas"
    case configuracion = "Configuración"
    case cerrarSesion = "Cerrar Sesión"
    
    
    var symbol: String {
        switch self {
        case .dashboard: return "house"
        //case .rutas: return "map"
        case .configuracion: return "gear"
        case .cerrarSesion: return "power"
        }
    }
    
    var id: String { self.rawValue }
}
