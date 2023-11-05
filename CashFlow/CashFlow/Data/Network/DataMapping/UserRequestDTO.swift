//
//  UserRequestDTO.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

struct UserRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case userUID = "userUID"
        case user_FIRST_NAME = "user_FIRST_NAME"
        case user_LAST_NAME = "user_LAST_NAME"
        case user_GENDER = "user_GENDER"
        case user_BIRTHDAY = "user_BIRTHDAY"
    }
    
    let userUID: String
    let user_FIRST_NAME: String
    let user_LAST_NAME: String
    let user_GENDER: String
    let user_BIRTHDAY: String
}

extension UserRequestDTO {
    static func fromDomain(user: User) -> UserRequestDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return .init(
            userUID: user.uuid,
            user_FIRST_NAME: user.firstName,
            user_LAST_NAME: user.lastName,
            user_GENDER: user.gender,
            user_BIRTHDAY: dateFormatter.string(from: user.birthDate)
        )
    }
}
