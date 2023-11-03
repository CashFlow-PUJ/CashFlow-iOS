//
//  IncomeRepository.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

protocol IncomeRepository {
    
    @discardableResult
    func getAllIncomeEntries(
        completion: @escaping (Result<[Income], Error>) -> Void
    ) -> Cancellable?
    
    func getIncomeEntryByID(
        incomeID: String,
        completion: @escaping (Result<Income, Error>) -> Void
    ) -> Cancellable?
    
    func createIncomeEntry(
        incomeEntry: Income,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?
    
    func updateIncomeEntry(
        incomeID: String,
        incomeEntry: Income,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?

    func deleteIncomeEntry()
}
