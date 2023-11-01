//
//  IncomeRequestDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 25/10/23.
//

import Foundation


struct IncomeRequestDTO: Encodable {
    /*
    private enum CodingKeys: String, CodingKey {
        case total = "record_TOTAL"
        case date = "record_DATE"
        case description = "record_DESCRIPTION"
        case category = "income_CATEGORY"
    }
    */
    /*
    private enum CodingKeys: String, CodingKey {
        case total = "record_total"
        case date = "record_date"
        case description = "record_description"
        case category = "income_category"
        
        case id = "record_id"
    }
    */
    
    //let record_id: String
    
    let record_total: Int
    let record_date: Double
    let record_description: String
    let income_category: String
}

extension IncomeRequestDTO {
    static func fromDomain(incomeEntry: Income) -> IncomeRequestDTO {
        
        return .init(record_total: incomeEntry.total,
                     record_date: incomeEntry.date.timeIntervalSince1970,
                     record_description: incomeEntry.description,
                     income_category: incomeEntry.category.rawValue
        )
        
        /*
        return .init(record_id: UUID().uuidString,
                     record_total: incomeEntry.total,
                     record_date: incomeEntry.date.timeIntervalSince1970,
                     record_description: incomeEntry.description,
                     income_category: incomeEntry.category.rawValue
        )
        */
    }
}
