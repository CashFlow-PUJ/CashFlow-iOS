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
}

