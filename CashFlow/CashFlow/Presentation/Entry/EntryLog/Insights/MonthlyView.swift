//
//  MonthlyView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 28/09/23.
//

import SwiftUI

struct MonthlyView: View {
    @State private var showChart = false
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        NavigationView {
            VStack{
                ChartViewMini(data: self.initData())
                    .frame(width: 390, height: 230, alignment: .center)
                    .opacity(showChart ? 0.0 : 1.0)
                               
                NavigationLink{
                    GraphicView(data: self.initData())
                }
                label: {
                    HStack {
                        Text("Ver informe mensual")
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 10, height: 10)
                    }
                    .foregroundColor(Color(hex: 0xF75E68))
                }
                Spacer()
            }
        }
    }
    
    func initData() -> [AnyEntry] {
        @State var ExpenseHistory: [Expense] = sharedData.expenseHistory
        @State var IncomeHistory: [Income] = sharedData.incomeHistory
        var previousTotal: Int = 0
        var info: [AnyEntry] = []
        for date in dateRangeArray {
            let matchingExpenses = ExpenseHistory.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            let matchingIncomes = IncomeHistory.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            
            let totalIncome = matchingIncomes.reduce(0, { $0 + $1.total })
            let totalExpense = matchingExpenses.reduce(0, { $0 + $1.total })
            
            let total = previousTotal + totalIncome - totalExpense
            
            info.append(AnyEntry(id: UUID(), total: total, date: date))
            previousTotal = total
        }
        
        info = info.filter { Calendar.current.component(.month, from: $0.date) == month}
        if info.isEmpty {
            info.append(AnyEntry(id: UUID(), total: previousTotal, date: Date()))
        }
            
        return info
    }

}

struct MonthlyViewExpenses: View {
    @State private var showChart = false
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        NavigationView {
            VStack{
                ChartViewExpensesMini(expenseData: self.initExpenseData())
                    .frame(width: 390, height: 230, alignment: .center)
                    .opacity(showChart ? 0.0 : 1.0)

                NavigationLink{
                    GraphicViewExpenses(expenseData: self.initExpenseData())
                }
                label: {
                    HStack {
                        Text("Ver informe mensual")
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 10, height: 10)
                    }
                    .foregroundColor(Color(hex: 0xF75E68))
                }
            }
        }
    }
    
    func initExpenseData() -> [AnyEntry] {
        @State var ExpenseHistory: [Expense] = sharedData.expenseHistory
        var previousTotal: Int = 0
        var info: [AnyEntry] = []
        for date in dateRangeArray {
            let matchingExpenses = ExpenseHistory.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
                        
            let totalExpense = matchingExpenses.reduce(0, { $0 + $1.total })
            
            let total = previousTotal + totalExpense
            
            info.append(AnyEntry(id: UUID(), total: total, date: date))
            previousTotal = total
        }
        
        info = info.filter { Calendar.current.component(.month, from: $0.date) == month}
        if info.isEmpty {
            info.append(AnyEntry(id: UUID(), total: previousTotal, date: Date()))
        }
            
        return info
    }
}
