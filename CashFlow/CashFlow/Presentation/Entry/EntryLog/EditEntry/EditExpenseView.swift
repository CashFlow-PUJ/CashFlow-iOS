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
    @State private var description: String = ""
    @State private var vendorName: String = ""
    @State private var ocrText: String = ""
    @State private var category: ExpenseCategory
    
    init(expense: Binding<Expense>, isPresented: Binding<Bool>, category: ExpenseCategory) {
        self._expense = expense
        self._isPresented = isPresented
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
                
                TextField("Description", text: $description)
                
                TextField("Vendor Name", text: $vendorName)
                
                TextField("OCR Text (if any)", text: $ocrText)
                
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
                self.description = self.expense.description ?? ""
                self.vendorName = self.expense.vendorName ?? ""
                self.category = self.expense.category
                self.ocrText = self.expense.ocrText ?? ""
            }
            
            Spacer()
        }
    }
    
    func saveExpense() {
        if let total = Int(self.total) {
            self.expense.total = total
            self.expense.description = self.description
            self.expense.vendorName = self.vendorName
            self.expense.category = self.category
            self.expense.ocrText = self.ocrText.isEmpty ? nil : self.ocrText
        }
        self.isPresented = false
    }
}
