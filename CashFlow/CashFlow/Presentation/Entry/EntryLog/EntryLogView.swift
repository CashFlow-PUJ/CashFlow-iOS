//
//  EntryLogView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 28/08/23.
//

import SwiftUI

struct EntryLogView: View {
    
    // MARK: - Coordinator
    @EnvironmentObject var coordinator: Coordinator
    
    // MARK: - ImageInput
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?

    // MARK: - EntryLog
    @State var firstTabBarIndex = 0
    @State var secondTabBarIndex = 0
    
    // MARK: - PopUp
    @State private var isShowingPopup = false

    // MARK: - CustomBar Categories
    @State private var selectedIncomeCategory: IncomeCategory = (IncomeCategory.allCases.first ?? .otros)
    @State private var selectedExpenseCategory: ExpenseCategory = (ExpenseCategory.allCases.first ?? .otros)
    
    // MARK: - Lateral Menu
    @State private var isShowingMenu = false
    @State private var isDataLoaded = false
    @State private var itemMenu: ItemMenu = (ItemMenu.allCases.first ?? .dashboard)
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        
        // MARK: - History
        @State var expenseHistory: [Expense] = sharedData.expenseHistory
        @State var incomeHistory: [Income] = sharedData.incomeHistory
        // TODO: Pass ViewModels to this View as parameters.
        /*
        @StateObject incomeHistoryViewModel = coordinator.appDIContainer.entryLogDIContainer.makeIncomeHistoryViewModel()
        @StateObject expenseHistoryViewModel = coordinator.appDIContainer.entryLogDIContainer.makeExpenseHistoryViewModel()
        */
        
        Group {
            if sharedData.dataLoaded {
                NavigationView {
                    ZStack(alignment: .bottomTrailing) {
                        
                        VStack {
                            HStack {
                                Button(
                                    action: {
                                        self.isShowingMenu.toggle()
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
                                            if (category == .total) {
                                                TotalButton(
                                                    isSelected: selectedIncomeCategory.rawValue == category.rawValue ? true : false,
                                                    title: category.rawValue,
                                                    value: 100,
                                                    total: incomeHistory.reduce(0) { $0 + $1.total},
                                                    color: category.color
                                                ){
                                                    selectedIncomeCategory = category
                                                }
                                            } else {
                                                CategoryButton(isSelected: selectedIncomeCategory.rawValue == category.rawValue ? true : false,
                                                               title: category.rawValue,
                                                               value: Int(percentageOfIncomes(for: category, using: incomeHistory)),
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
                                                TotalButton(
                                                    isSelected: selectedExpenseCategory.rawValue == category.rawValue ? true : false,
                                                    title: category.rawValue,
                                                    value: 100,
                                                    total: expenseHistory.reduce(0) {$0 + $1.total},
                                                    color: category.color
                                                ){
                                                    selectedExpenseCategory = category
                                                }
                                            } else {
                                                CategoryButton(isSelected: selectedExpenseCategory.rawValue == category.rawValue ? true : false,
                                                               title: category.rawValue,
                                                               value: Int(percentageOfExpenses(for: category, sharedData: sharedData)),
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
                                    IncomeHistoryView(
                                        categoryFilter: $selectedIncomeCategory,
                                        viewModel: coordinator.appDIContainer.entryLogDIContainer.makeIncomeHistoryViewModel(sharedData: sharedData)
                                    )
                                    .environmentObject(sharedData)
                                }
                                else {
                                    ExpenseHistoryView(
                                        categoryFilter: $selectedExpenseCategory,
                                        viewModel: coordinator.appDIContainer.entryLogDIContainer.makeExpenseHistoryViewModel(sharedData: sharedData)
                                    )
                                }
                            }
                            else {
                                // TODO: Insights View
                                if firstTabBarIndex == 0 {
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
                        .sheet(isPresented: $showImagePicker){
                            ImageInputViewControllerRepresentable()
                        }
                        
                        if isShowingMenu {
                            Color.black.opacity(0.6)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    isShowingMenu = false
                                    // TODO: Uncomment before commiting
                                    /*
                                    withAnimation(.smooth(duration: 0.8)){
                                        isShowingMenu = false
                                    }
                                    */
                                }
                            HStack {
                                Color.white
                                    .shadow(radius: 20)
                                    .frame(width: (UIScreen.main.bounds.width / 2) + 50, height: UIScreen.main.bounds.height + 10)
                                    .overlay(
                                        MenuView(selectedItem: $itemMenu)
                                    )
                                    .offset(x: isShowingMenu ? 0 : -(UIScreen.main.bounds.width / 2))
                                Spacer()
                            }
                        }
                        
                        Button(
                            action: {
                                if firstTabBarIndex == 0 {
                                    self.isShowingPopup.toggle()
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
                        
                        if isShowingPopup {
                            Color.black.opacity(0.6)
                               .edgesIgnoringSafeArea(.all)
                               .onTapGesture {
                                   isShowingPopup = false
                                   // TODO: Uncomment before commiting
                                   /*
                                   withAnimation(.bouncy(duration: 0.3)){
                                       isShowingPopup = false
                                   }
                                    */
                               }
                            Color.white
                                .cornerRadius(50)
                                .shadow(radius: 20)
                                .frame(width: 360, height: 400)
                                .overlay(
                                    PopUpIncomeView(isPresented: self.$isShowingPopup)
                                    .frame(width: 300, height: 380)
                                )
                                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker){
                    ImageInputViewControllerRepresentable()
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: sharedData.incomeHistory) { newValue in
            checkDataLoaded()
        }
        .onChange(of: sharedData.expenseHistory) { newValue in
            checkDataLoaded()
        }
    }
    
    func loadData() {
        var bool = false
        coordinator.appDIContainer.entryLogDIContainer.makeIncomeHistoryViewModel(sharedData: sharedData)
        coordinator.appDIContainer.entryLogDIContainer.makeExpenseHistoryViewModel(sharedData: sharedData)
        while !bool {
            if sharedData.incomeHistory.count == 0 && sharedData.expenseHistory.count == 0 {
                print("Nothing")
                sleep(2)
            }else{
                bool = true
            }
        }
    }
    
    func checkDataLoaded() {
        if !sharedData.incomeHistory.isEmpty || !sharedData.expenseHistory.isEmpty {
            sharedData.dataLoaded = true
            sharedData.changeData()
        }
    }
}



func percentageOfExpenses(for category: ExpenseCategory, sharedData: SharedData) -> Double {
    @State var ExpenseHistory: [Expense] = sharedData.expenseHistory
    
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

func percentageOfIncomes(for category: IncomeCategory, using incomeHistory: [Income]) -> Double {
    let totalIncome = Double(incomeHistory.reduce(0) { $0 + ($1.category == category ? $1.total : 0) })
    let totalAllIncomes = Double(incomeHistory.reduce(0) { $0 + $1.total })
    
    if totalAllIncomes > 0 {
        return customRounded((totalIncome / totalAllIncomes) * 100.0)
    } else {
        return 0.0
    }
}
