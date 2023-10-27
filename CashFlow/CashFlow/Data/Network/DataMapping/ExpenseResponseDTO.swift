//
//  ExpenseResponseDTO.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

// MARK: - Data Transfer Object
struct ExpenseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "record_id"
        case total = "record_total"
        case date = "record_date"
        case description = "record_description"
        case vendorName
        case category = "expense_category"
        case ocrText = "ocr_txt"
    }
    
    let id: String
    let total: Int
    let date: Double
    let description: String?
    let vendorName: String?
    let category: ExpenseCategory.RawValue
    let ocrText: String?
}

extension ExpenseDTO {
    func toDomain() -> Expense {
        return .init(id: UUID(uuidString: id.description) ?? UUID(),
                     total: total,
                     date: Date(timeIntervalSince1970: date),
                     description: description,
                     vendorName: vendorName,
                     category: ExpenseCategory(rawValue: category) ?? ExpenseCategory.otros,
                     ocrText: ocrText)
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
