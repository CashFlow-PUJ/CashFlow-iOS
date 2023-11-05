//
//  UserGender.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

enum Gender: String {
    case male = "m"
    case female = "f"

    var displayName: String {
        switch self {
        case .male:
            return "Masculino"
        case .female:
            return "Femenino"
        }
    }

    init?(from string: String) {
        switch string {
        case "m", "M", "Masculino", "masculino":
            self = .male
        case "f", "F", "Femenino", "femenino":
            self = .female
        default:
            return nil
        }
    }
}
