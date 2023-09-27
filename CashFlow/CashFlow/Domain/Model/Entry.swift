//
//  Entry.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 26/09/23.
//

import Foundation

protocol Entry: Identifiable {
    var id: UUID { get set }
    var total: Double { get set }
    var date: Date { get set }
    var description: String { get set }
}
