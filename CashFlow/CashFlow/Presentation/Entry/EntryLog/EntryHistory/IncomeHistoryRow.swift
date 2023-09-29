//
//  IncomeHistoryRow.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct IncomeHistoryRow: View {
    
    var entry: Income
    
    var body: some View {
        HStack {
            // TODO: Render different icon given the 'Category' enumerate value
            Image(systemName: entry.category.symbol)
                .resizable()
                .renderingMode(.original)
                .foregroundColor(.secondary)
                .frame(width: 32, height: 32)
            VStack {
                Text(entry.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(Color(hex: 0x707070))
                    .lineLimit(1)
                Text(entry.date.formatted(.dateTime))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(hex: 0x989EB1))
            }
            Spacer()
            Text((entry.total.formatted(.currency(code: "COP"))))
                .foregroundColor(Color(hex: 0x989EB1))
        }
        .padding(.vertical, 10)
        .cornerRadius(10)
        .onTapGesture {
            // TODO: Navigate / Show Transaction Detail View
            // TODO: Ripple effect / Feedback de presión al usuario.
        }
    }
}
