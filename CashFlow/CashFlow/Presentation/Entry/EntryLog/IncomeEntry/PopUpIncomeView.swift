//
//  PopUpIncomeView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 30/09/23.
//

import SwiftUI

struct PopUpIncomeView: View {
    
    @Binding var isPresented: Bool
    @State private var selectedPopupCategory: IncomeCategory = IncomeCategory.allCases.dropFirst().first ?? .salario
    
    @State private var date = Date()
    @State private var descripcion = ""
    @State private var total = ""
    @State private var isNumeric = true
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Adicionar Ingreso")
                .font(.title)
                .padding()
            Spacer()
            HStack {
                Text("Fecha del ingreso: ")
                    .alignmentGuide(.leading) { _ in 0 }
                Spacer()
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date]
                ).padding(.trailing, 19)
            }
            HStack {
                Text("Descripción: ")
                    .alignmentGuide(.leading) { _ in 0 } // Alinea a la izquierda
                TextField("Ingrese el detalle del Ingreso", text: $descripcion)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Text("Valor:             ")
                    .alignmentGuide(.leading) { _ in 0 }// Alinea a la izquierda
                TextField("Ingrese el total", text: $total)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            if !isNumeric {
                Text("Ingrese un valor numérico válido")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
            
            HStack {
                Text("Categoría")
                Picker("Categoría de Ingreso", selection: $selectedPopupCategory ) {
                    ForEach(IncomeCategory.allCases.dropFirst()) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.inline)
            }
            
            Button("Guardar") {
                if !descripcion.isEmpty && !total.isEmpty && isNumeric {
                    let newIncome = Income(
                        id: UUID(),
                        total: Int(total) ?? 0,
                        date: date,
                        description: descripcion,
                        category: selectedPopupCategory
                    )
                    
                    Income.sampleData.append(newIncome)
                    isPresented.toggle() // Cierra el cuadro emergente
                }

            }
            .padding()
            .disabled(descripcion.isEmpty || total.isEmpty || !isNumeric || Int(total)! <= 0)
                    
        }
        .onTapGesture {
            // Cierra el teclado cuando se toca fuera del TextField
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: total) { newValue in
            // Validar si el valor ingresado es numérico
            isNumeric = isNumericInput(newValue)
        }
    }
}

func isNumericInput(_ input: String) -> Bool {
    let scanner = Scanner(string: input)
    if (Int(input) ?? 0 <= 0){
        return false
    }else {
        return scanner.scanInt(nil) && scanner.isAtEnd
    }
}
