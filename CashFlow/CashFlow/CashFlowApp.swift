//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI

@main
struct CashFlowApp: App {
    var body: some Scene {
        WindowGroup {
            
            var userIsAuthenticated = true
            
            // IF USER IS NOT AUTHENTICATED
            if(!userIsAuthenticated) {
                LoginView()
                    .preferredColorScheme(.light)
            }
            else {
                TransactionLog()
                    .preferredColorScheme(.light)
            }
        }
    }
}
