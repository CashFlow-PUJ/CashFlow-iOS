
//
//  ChartVendorModel.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 6/11/23.
//

import Foundation

struct PieChartDatum: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var value: Double
    var total: Double
}

extension [PieChartDatum] {
    func findValues(_ on: String) -> Double? {
        if let value = self.first(where: {
            $0.name == on
        }) {
            return value.value
        }
        return nil
    }
    
    func index(_ on: String) -> Int {
        if let index = self.firstIndex(where: {
            $0.name == on
        }) {
            return index
        }
        return 0
    }
}
