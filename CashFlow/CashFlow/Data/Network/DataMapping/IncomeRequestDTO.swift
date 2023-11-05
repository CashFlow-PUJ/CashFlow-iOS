struct IncomeRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case record_total = "record_TOTAL"
        case record_date = "record_DATE"
        case record_description = "record_DESCRIPTION"
        case income_category = "income_CATEGORY"
    }
    
    let record_total: String
    let record_date: Double
    let record_description: String
    let income_category: String
}

extension IncomeRequestDTO {
    static func fromDomain(incomeEntry: Income) -> IncomeRequestDTO {
        return .init(
            record_total: "\(incomeEntry.total)",
            record_date: incomeEntry.date.timeIntervalSince1970,
            record_description: incomeEntry.description,
            income_category: incomeEntry.category.rawValue
        )
    }
}
