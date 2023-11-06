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
    @State private var showDeletionAlert: Bool = false
    @State private var selectedDate = Date()
    
    @ObservedObject var viewModel: ExpenseHistoryView.ExpenseHistoryViewModel
    
    
    init(expense: Binding<Expense>, isPresented: Binding<Bool>, category: ExpenseCategory, viewModel: ExpenseHistoryView.ExpenseHistoryViewModel) {
        self._expense = expense
        self._isPresented = isPresented
        self._category = State(initialValue: category)
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("ID: \(expense.id.uuidString)")
            
            Spacer()
            
            Form {
                
                Section(header: Text("Total")) {
                    TextField("Total", text: $total)
                }
                
                Section(header: Text("Descripción")) {
                    TextField("Descripción", text: $description)
                }
                
                Section(header: Text("Vendedor y/o Almacen")) {
                    TextField("Vendedor", text: $vendorName)
                }
                
                Section(header: Text("Categoría")) {
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("OCR")) {
                    TextField("OCR Text (if any)", text: $ocrText)
                }
                
                Section(header: Text("Fecha de Gasto")) {
                    DatePicker("Selecciona la fecha", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                HStack {
                    Spacer()
                    Button("Guardar") {
                        saveExpense()
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        showDeletionAlert = true
                    }) {
                        Text("Eliminar")
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .alert(isPresented: $showDeletionAlert) {
                    Alert(
                        title: Text("Confirmar eliminación"),
                        message: Text("¿Estás seguro de que quieres eliminar esta entrada?"),
                        primaryButton: .destructive(Text("Eliminar")) {
                            deleteExpense(id: expense.id.uuidString)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .onAppear {
                self.total = String(self.expense.total)
                self.description = self.expense.description ?? ""
                self.vendorName = self.expense.vendorName ?? ""
                self.category = self.expense.category
                self.ocrText = self.expense.ocrText ?? ""
                self.selectedDate = self.expense.date
            }
            
            Spacer()
        }
    }
    
    func saveExpense() {
        if let totalInt = Int(self.total) {
            let updatedExpense = Expense(
                id: expense.id,
                total: totalInt,
                date: self.selectedDate,
                description: self.description.isEmpty ? nil : self.description,
                vendorName: self.vendorName.isEmpty ? nil : self.vendorName,
                category: self.category,
                ocrText: self.ocrText.isEmpty ? nil : self.ocrText
            )
            viewModel.updateExpenseEntry(expenseID: expense.id.uuidString, updatedExpense: updatedExpense)
            self.isPresented = false
        }
    }

    
    func deleteExpense(id: String) {
        viewModel.deleteExpense(expenseID: id)
        self.isPresented = false
    }
}
