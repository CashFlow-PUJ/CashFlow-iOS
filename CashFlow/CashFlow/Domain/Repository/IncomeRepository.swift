//
//  IncomeRepository.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

protocol IncomeRepository {
    func getAllIncomeEntries(query: String,
                             completion: @escaping (Result<[Income], Error>) -> Void
    ) -> Cancellable?
    func getIncomeEntryByID() -> Income?
    func createIncomeEntry() -> Income
    func updateIncomeEntry() -> Bool
    func deleteIncomeEntry()
}
