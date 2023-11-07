//
//  ChartMonthlyViewExpenses.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 6/11/23.
//

import SwiftUI
import Charts

struct GraphicViewExpenses: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ChartViewExpenses()
                    .frame(width: 1000, height: 300)
            }
        }
    }
}

var expenseData: [AnyEntry] = initData()

struct ChartViewExpenses: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Chart(expenseData) { data in
                    LineMark(
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Money", data.total)
                    )
                    PointMark (
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Money", data.total)
                    )
                    .symbolSize(1)
                    .annotation(
                        position: .overlay,
                        alignment: .bottom,
                        spacing: 10
                    ){
                        Text("\(String(Double(data.total/1000000)))M")
                            .font(.system(size: 8))
                    }
                    
                }
                .navigationTitle("Informe Mensual")
                .padding(30)
                .chartXAxis{
                    AxisMarks(values: .stride(by: .day)){ day in
                        AxisValueLabel(format: .dateTime.day(.defaultDigits))
                        AxisGridLine()
                    }
                }
                
                
                Spacer()
            }
        }
    }
}

struct ChartViewExpensesMini: View {
    var body: some View {
        GeometryReader { geometry in
            Chart(expenseData) { data in
                LineMark(
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Money", data.total)
                )
                
            }
            Spacer()
        }
    }
}

struct ExpenseChartViewMini: View {
    var body: some View {
        GeometryReader { geometry in
            Chart(expenseData) { data in
                LineMark(
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Money", data.total)
                )
                
            }
            Spacer()
        }
    }
}

func initExpenseData() -> [AnyEntry] {
    @State var ExpenseHistory: [Expense] = Expense.sampleData
    //@State var IncomeHistory: [Income] = Income.sampleData
    var previousTotal: Int = 0
    var info: [AnyEntry] = []
    for date in dateRangeArray {
        let matchingExpenses = ExpenseHistory.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        //let matchingIncomes = IncomeHistory.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        
        //let totalIncome = matchingIncomes.reduce(0, { $0 + $1.total })
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
