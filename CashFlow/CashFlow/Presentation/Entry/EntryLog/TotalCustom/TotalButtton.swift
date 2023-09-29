//
//  TotalButtton.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 29/09/23.
//

import SwiftUI
import Charts

struct TotalButtton: View {
    
    var isSelected: Bool
    var title: String
    
    var value: Int
    var total: Int
    var color: Color
    
    var action: () -> Void
    
    private var data: [ChartData] {
        [
            // TODO: Associate a color to each Expense and Income Category.
            ChartData(color: Color(hex: 0xEFF0F2), value: 100 - CGFloat(self.value), total: 100 - self.value),
            ChartData(color: self.color, value: CGFloat(self.value), total: self.total)
        ]
    }
    
    var body: some View {
        Button(
            action: self.action,
            label: {
                TotalCustomView(title: "Total", chartData: data)
                    .background(isSelected ? Color(hex: 0xF7F7F9) : .white)
                    .cornerRadius(25)
            }
        )
    }
}
