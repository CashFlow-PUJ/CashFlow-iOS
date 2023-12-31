//
//  CategoryButton.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct CategoryButton: View {
    
    var isSelected: Bool
    var title: String
    
    // TODO: Compute or pass 'value' property value
    var value: Int
    var color: Color
    
    private var data: [ChartData] {
        [
            ChartData(color: Color(hex: 0xEFF0F2), value: 100 - CGFloat(self.value), total: 0),
            ChartData(color: self.color, value: CGFloat(self.value), total: 0)
        ]
    }
    
    var action: () -> Void
    
    var body: some View {
        Button(
            action: self.action,
            label: {
                MiniDonut(title: self.title, chartData: data)
                    .background(isSelected ? Color(hex: 0xF7F7F9) : .white)
                    .cornerRadius(25)
            }
        )
    }
}
