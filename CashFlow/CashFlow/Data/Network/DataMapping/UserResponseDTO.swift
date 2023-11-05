//
//  UserResponseDTO.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

// MARK: - Data Transfer Object
struct UserDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case uuid
        case birthDate = "user_birthDate"
        case gender = "user_gender"
        case firstName = "user_first_name"
        case lastName = "user_last_name"
    }
    
    let uuid: String
    let birthDate: String
    let gender: String
    let firstName: String
    let lastName: String
}

extension UserDTO {
    func toDomain() -> User {
        return .init(uuid: uuid,
                     birthDate: dateFormatter.date(from: birthDate) ?? Date(),
                     gender: gender,
                     firstName: firstName,
                     lastName: lastName)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
