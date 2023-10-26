//
//  IncomeResponseDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/10/23.
//

import Foundation


struct IncomeDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "record_id"
        case total = "record_total"
        case date = "record_date"
        case description = "record_description"
        case category = "income_category"
    }
    
    let id: String
    let total: Int
    let date: Date
    let description: String
    let category: String
}


extension IncomeDTO {
    func toDomain() -> Income {
        return .init(
            id: UUID(uuidString: id.description) ?? UUID(),
            total: total,
            date: date,
            description: description,
            category: IncomeCategory(rawValue: category) ?? IncomeCategory.otros)
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
