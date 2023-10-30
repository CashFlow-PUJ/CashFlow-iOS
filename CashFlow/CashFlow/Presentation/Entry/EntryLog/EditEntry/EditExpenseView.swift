//
//  EditEntryView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 26/10/23.
//

import SwiftUI

struct EditExpenseView: View {
    @Binding var expense: Expense
    @Binding var isPresented: Bool
    
    @State private var total: String = ""
    @State private var vendor: String = ""
    @State private var category: ExpenseCategory
    
    init(expense: Binding<Expense>, isPresented: Binding<Bool>, category: ExpenseCategory) {
        self._expense = expense
        self._isPresented = isPresented  // Asegúrate de usar _isPresented aquí
        self._category = State(initialValue: category)
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("ID: \(expense.id.uuidString)")
            
            Spacer()
            
            Form {
                TextField("Total", text: $total)
                    .keyboardType(.decimalPad)
                
                TextField("Vendor Name", text: $vendor)
                
                Picker("Category", selection: $category) {
                    ForEach(ExpenseCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Button("Save") {
                    saveExpense()
                }
            }
            .onAppear {
                self.total = String(self.expense.total)
                self.vendor = self.expense.vendorName ?? ""
                self.category = self.expense.category
            }
            
            Spacer()
        }
    }
    
    func saveExpense() {
        if let total = Int(self.total) {
            self.expense.total = total
            self.expense.vendorName = self.vendor
            self.expense.category = self.category
        }
        self.isPresented = false
    }
    
    
}

