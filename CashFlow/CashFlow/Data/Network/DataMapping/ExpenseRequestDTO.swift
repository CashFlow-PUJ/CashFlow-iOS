struct ExpenseRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case record_total = "record_TOTAL"
        case record_date = "record_DATE"
        case record_description = "record_DESCRIPTION"
        case expense_category = "expense_CATEGORY"
        case ocr_text = "ocr_TEXT"
    }
    
    let record_total: String
    let record_date: Double
    let record_description: String
    let expense_category: String
    let ocr_text: String
}

extension ExpenseRequestDTO {
    static func fromDomain(expenseEntry: Expense) -> ExpenseRequestDTO {
        return .init(
            record_total: "\(expenseEntry.total)",
            record_date: expenseEntry.date.timeIntervalSince1970,
            record_description: expenseEntry.vendorName ?? "",
            expense_category: expenseEntry.category.rawValue,
            ocr_text: expenseEntry.ocrText ?? ""
        )
    }
}
