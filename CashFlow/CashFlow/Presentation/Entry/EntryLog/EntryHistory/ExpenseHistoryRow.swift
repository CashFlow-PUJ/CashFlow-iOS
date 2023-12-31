//
//  ExpenseHistoryRow.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct ExpenseHistoryRow: View {
    
    var entry: Expense
    
    @Binding var selectedEntry: Expense?
    @ObservedObject var viewModel: ExpenseHistoryView.ExpenseHistoryViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Image(systemName: entry.category.symbol)
                .resizable()
                .renderingMode(.original)
                .foregroundColor(.secondary)
                .colorMultiply(.secondary)
                .frame(width: 28, height: 28)
            VStack {
                Text(entry.vendorName ?? "")
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
            self.selectedEntry = entry
            self.isPresented.toggle()
        }
        .onChange(of: selectedEntry) { newValue in
            if newValue != nil {
                self.isPresented = true
            }
        }
        .sheet(isPresented: $isPresented) {
            if let selectedEntry = self.selectedEntry {
                EditExpenseView(expense: .constant(self.selectedEntry!), isPresented: self.$isPresented, category: selectedEntry.category, viewModel: viewModel)
            } else {
                Text("No entry selected")
            }
        }
    }
}
