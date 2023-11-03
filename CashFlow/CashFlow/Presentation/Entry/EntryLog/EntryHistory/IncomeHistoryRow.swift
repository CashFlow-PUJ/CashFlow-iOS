//
//  IncomeHistoryRow.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct IncomeHistoryRow: View {
    
    var entry: Income
    @Binding var selectedEntry: Income?
    @State private var isSheetPresented: Bool = false
    @ObservedObject var viewModel: IncomeHistoryView.IncomeHistoryViewModel

    var body: some View {
        HStack {
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
            self.selectedEntry = entry
            self.isSheetPresented.toggle()
        }
        .onChange(of: selectedEntry) { newValue in
            if newValue != nil {
                self.isSheetPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            if let selectedEntry = self.selectedEntry {
                EditIncomeView(income: .constant(self.selectedEntry!), isPresented: self.$isSheetPresented, category: selectedEntry.category, viewModel: viewModel)
            } else {
                Text("No entry selected")
            }
        }
    }
}
