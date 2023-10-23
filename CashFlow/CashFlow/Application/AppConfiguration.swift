//
//  AppConfiguration.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        // TODO: Uncomment the following once the Backend is set.
        /*
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        */
        let apiBaseURL = "https://6536b68fbb226bb85dd28959.mockapi.io"
        return apiBaseURL
    }()
}
