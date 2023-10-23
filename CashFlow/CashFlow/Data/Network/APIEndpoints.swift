//
//  APIEndpoints.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation
import Alamofire

struct APIEndpoints {
    static func getAllExpenseEntries() -> Endpoint<ExpenseResponseDTO> {
        return Endpoint(
            path: "/expense/GET",
            method: .get
        )
    }
    
    
}
