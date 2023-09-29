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
                        .padding(20)
                    if firstTabBarIndex == 0 { // Este es la pestaña Ingresos
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                
                                ForEach(IncomeCategory.allCases) { category in
                                    if (category == .total){
                                        TotalButtton(
                                            isSelected: selectedIncomeCategory.rawValue == category.rawValue ? true : false,
                                            title: "Total",
                                            value: 100,
                                            total: IncomeHistory.reduce(0) { $0 + $1.total},
                                            color: category.color
                                        ){
                                            selectedIncomeCategory = category
                                        }
                                    } else {
                                        CategoryButton(isSelected: selectedIncomeCategory.rawValue == category.rawValue ? true : false,
                                                       title: category.rawValue,
                                                       value: Int(percentageOfIncomes(for: category)),
                                                       color: category.color
                                        ) {
                                            selectedIncomeCategory = category
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(ExpenseCategory.allCases) { category in
                                    if (category == .total) {
                                        TotalButtton(
                                            isSelected: selectedExpenseCategory.rawValue == category.rawValue ? true : false,
                                            title: "Total",
                                            value: 100,
                                            total: ExpenseHistory.reduce(0) {$0 + $1.total},
                                            color: category.color
                                        ){
                                            selectedExpenseCategory = category
                                        }
                                    }else{
                                        CategoryButton(isSelected: selectedExpenseCategory.rawValue == category.rawValue ? true : false,
                                                       title: category.rawValue,
                                                       value: Int(percentageOfExpenses(for: category)),
                                                       color: category.color
                                        ) {
                                            selectedExpenseCategory = category
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    CustomTopTabBar(tabIndex: $secondTabBarIndex, tabTitles: ["Historial", "Insights"]).padding(15)
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
                            MonthlyView()
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

func percentageOfExpenses(for category: ExpenseCategory) -> Double {
    let totalExpenses = Double(ExpenseHistory.reduce(0) { $0 + ($1.category == category ? $1.total : 0) })
    let totalAllExpenses = Double(ExpenseHistory.reduce(0) { $0 + $1.total })
    
    if totalAllExpenses > 0 {
        return customRounded((totalExpenses / totalAllExpenses) * 100.0)
    } else {
        return 0.0
    }
}

func customRounded(_ value: Double) -> Double {
    let fractionalPart = value - floor(value)
    if fractionalPart >= 0.5 {
        return ceil(value)
    } else {
        return floor(value)
    }
}

func percentageOfIncomes(for category: IncomeCategory) -> Double {
    let totalIncome = Double(IncomeHistory.reduce(0) { $0 + ($1.category == category ? $1.total : 0) })
    let totalAllIncomes = Double(IncomeHistory.reduce(0) { $0 + $1.total })
    
    if totalAllIncomes > 0 {
        return customRounded((totalIncome / totalAllIncomes) * 100.0)
    } else {
        return 0.0
    }
}
