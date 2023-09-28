//
//  EntryLogView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 28/08/23.
//

import SwiftUI

struct EntryLogView: View {
    
    // MARK: - ImageInput
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?

    // MARK: - EntryLog
    @State var firstTabBarIndex = 0
    @State var secondTabBarIndex = 0

    @State private var selectedIncomeCategory: IncomeCategory = (IncomeCategory.allCases.first ?? .otros)
    @State private var selectedExpenseCategory: ExpenseCategory = (ExpenseCategory.allCases.first ?? .otros)
   
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    HStack {
                        Button(
                            action: {
                                // TODO: Show Lateral Menu
                            },
                            label: {
                                Image(systemName: "text.justify")
                                    .renderingMode(.original)
                                    .foregroundColor(Color(hex: 0xF75E68))
                                    .font(.title)
                            }
                        )
                        .padding(.horizontal, 10)
                        
                        Text("Registro")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    CustomTopTabBar(tabIndex: $firstTabBarIndex, tabTitles: ["Ingresos", "Gastos"])
                    if firstTabBarIndex == 0 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(IncomeCategory.allCases) { category in
                                    CategoryButton(isSelected: selectedIncomeCategory.rawValue == category.rawValue ? true : false,
                                                   title: category.rawValue,
                                                   // TODO: ¿De dónde debe salir el valor (porcentaje) mostrado?
                                                   value: 35,
                                                   // TODO: ¿Dónde se almacena el color de la categoría?
                                                   color: .orange
                                    ) {
                                        selectedIncomeCategory = category
                                    }
                                }
                            }
                        }
                    }
                    else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(ExpenseCategory.allCases) { category in
                                    CategoryButton(isSelected: selectedExpenseCategory.rawValue == category.rawValue ? true : false,
                                                   title: category.rawValue,
                                                   // TODO: ¿De dónde debe salir el valor (porcentaje) mostrado?
                                                   value: 35,
                                                   // TODO: ¿Dónde se almacena el color de la categoría?
                                                   color: .orange
                                    ) {
                                        selectedExpenseCategory = category
                                    }
                                }
                            }
                        }
                    }
                    
                    CustomTopTabBar(tabIndex: $secondTabBarIndex, tabTitles: ["Historial", "Insights"])
                    if secondTabBarIndex == 0 {
                        if firstTabBarIndex == 0 {
                            // Display income related history
                            IncomeHistoryView(categoryFilter: $selectedIncomeCategory)
                        }
                        else {
                            // Display expense related history
                            ExpenseHistoryView(categoryFilter: $selectedExpenseCategory)
                        }
                    }
                    else {
                        // TODO: Insights View
                        if firstTabBarIndex == 0 {
                            // Display income related insights
                            Spacer()
                        }
                        else {
                            // Display expense related insights
                            Spacer()
                        }
                    }
                    
                }
                .padding()
                
                Button(
                    action: {
                        if firstTabBarIndex == 0 {
                            // Income entry
                            // TODO: Income Entry Form/View
                        }
                        else {
                            // Expense entry (OCR / Camera available)
                            self.showImagePicker = true
                        }
                    },
                    label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color(hex: 0xF75E68))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                )
                .padding(.all, 25)
            }
        }
        .sheet(isPresented: $showImagePicker){
            ImageInputViewControllerRepresentable()
        }
    }    
}
