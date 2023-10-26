//
//  IncomeRequestDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 25/10/23.
//

import Foundation


struct IncomeRequestDTO: Encodable {
    private enum CodingKeys: String, CodingKey {
        case total = "record_TOTAL"
        case date = "record_DATE"
        case description = "record_DESCRIPTION"
        case category = "income_CATEGORY"
    }
    //let userID: String
    let total: Int
    let date: Date
    let description: String
    let category: String
}

extension IncomeRequestDTO {
    static func fromDomain(incomeEntry: Income) -> IncomeRequestDTO {
        return .init(total: incomeEntry.total,
                     date: incomeEntry.date,
                     description: incomeEntry.description,
                     category: incomeEntry.category.rawValue
        )
    }
}
