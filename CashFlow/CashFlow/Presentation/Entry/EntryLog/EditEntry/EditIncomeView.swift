//
//  EditEntryView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 26/10/23.
//

import SwiftUI

struct EditIncomeView: View {
    @Binding var income: Income
    @Binding var isPresented: Bool
    
    @State private var total: String = ""
    @State private var description: String = ""
    @State private var category: IncomeCategory
    @State private var showDeletionAlert: Bool = false
    @ObservedObject var viewModel: IncomeHistoryView.IncomeHistoryViewModel
    @State private var selectedDate = Date()
    
    init(income: Binding<Income>, isPresented: Binding<Bool>, category: IncomeCategory, viewModel: IncomeHistoryView.IncomeHistoryViewModel) {
        self._income = income
        self._isPresented = isPresented
        self._category = State(initialValue: category)
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("ID: \(income.id.uuidString)")
            
            Spacer()
            
            Form {
                
                Section(header: Text("Total")) {
                    TextField("Total", text: $total)
                }
                
                Section(header: Text("Descripción")) {
                    TextField("Descripción", text: $description)
                }
                
                Section(header: Text("Categoría")) {
                    Picker("Category", selection: $category) {
                        ForEach(CashFlow.IncomeCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Fecha de ingreso")) {
                    DatePicker("Selecciona la fecha", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                HStack {
                    Spacer()
                    Button("Guardar") {
                        saveIncome()
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
                            deleteIncome(id: income.id.uuidString)
                        },
                        secondaryButton: .cancel()
                    )
                }

                
            }
            .onAppear {
                self.total = String(self.income.total)
                self.description = self.income.description
                self.category = self.income.category
                self.selectedDate = self.income.date
            }
            
            Spacer()
        }
    }
    
    func saveIncome() {
        if let total = Int(self.total) {
            var updatedIncome = self.income
            updatedIncome.total = total
            updatedIncome.description = self.description
            updatedIncome.category = self.category
            updatedIncome.date = self.selectedDate
            
            viewModel.updateIncomeEntry(incomeID: income.id.uuidString, updatedIncome: updatedIncome)
            self.isPresented = false
        }
    }
    
    func deleteIncome(id: String) {
        viewModel.deleteIncomeEntry(incomeID: id)
        self.isPresented = false
    }
    
    
}

