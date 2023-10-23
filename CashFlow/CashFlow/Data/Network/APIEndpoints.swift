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
            path: "https://cashflow-400217.uc.r.appspot.com/expense/GET",
            isFullPath: true,
            method: .get
        )
    }
    
    
}
