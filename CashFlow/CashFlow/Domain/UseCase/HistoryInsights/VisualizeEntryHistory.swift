//
//  VisualizeEntryHistory.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 27/09/23.
//

import Foundation

protocol VisualizeEntryHistory {
    associatedtype Entry
    
    func execute(
        type: String,
        completion: @escaping (Result<[Entry], Error>) -> Void
    ) -> Cancellable?
}

struct VisualizeExpenseHistory: VisualizeEntryHistory {
    
    private let expenseRepository: ExpenseRepository
    
    init(
        expenseRepository: ExpenseRepository
    ) {
        self.expenseRepository = expenseRepository
    }
    
    // TODO: Check if this 'type' parameter is a good practice.
    func execute(
        type: String,
        completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.getAllExpenseEntries(
            query: "",
            completion: { result in
                if case .success = result {
                    // TODO: ¿Qué debe ir en este bloque?
                }
                completion(result)
            }
        )
    }
}

struct VisualizeIncomeHistory: VisualizeEntryHistory {
    private let incomeRepository: IncomeRepository
    
    init(
        incomeRepository: IncomeRepository
    ) {
        self.incomeRepository = incomeRepository
    }
    
    // TODO: Check if this 'type' parameter is a good practice.
    func execute(
        type: String,
        completion: @escaping (Result<[Income], Error>) -> Void
    ) -> Cancellable? {
        return incomeRepository.getAllIncomeEntries(
            query: "",
            completion: { result in
                if case .success = result {
                    // TODO: ¿Qué debe ir en este bloque?
                }
                completion(result)
            })
    }
}
