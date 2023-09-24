//
//  CategoryButton.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct CategoryButton: View {
    
    @Binding var isSelected: Bool
    
    // TODO: ChartData debería ser capaz de tener los valores resaltado y sin resaltar en el mismo objeto. No hacer dos objetos ChartData para conseguir que el donut tenga los dos valores.
    var data: [ChartData]
    
    var action: () -> Void
    
    var body: some View {
        Button(
            action: self.action,
            label: {
                MiniDonut(title: "Salario", chartData: data)
                    .background(isSelected ? Color(hex: 0xF7F7F9) : .white)
                    .cornerRadius(25)
            }
        )
    }
}
