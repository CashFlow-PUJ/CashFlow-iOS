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
        completion: @escaping (Result<[Entry], Error>) -> Void
    ) -> Cancellable?
}

final class VisualizeExpenseHistory: VisualizeEntryHistory {
    
    private let expenseRepository: ExpenseRepository
    
    init(
        expenseRepository: ExpenseRepository
    ) {
        self.expenseRepository = expenseRepository
    }
    
    func execute(
        completion: @escaping (Result<[Expense], Error>) -> Void
    ) -> Cancellable? {
        return expenseRepository.getAllExpenseEntries(
            //query: "",
            completion: { result in completion(result) }
        )
    }
}

final class VisualizeIncomeHistory: VisualizeEntryHistory {
    private let incomeRepository: IncomeRepository
    
    init(
        incomeRepository: IncomeRepository
    ) {
        self.incomeRepository = incomeRepository
    }
    
    func execute(
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
