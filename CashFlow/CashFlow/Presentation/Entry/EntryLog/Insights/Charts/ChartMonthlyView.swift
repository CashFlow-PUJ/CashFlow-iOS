//
//  ChartMonthlyView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 29/09/23.
//

import SwiftUI
import Charts


let dateRangeArray = dateRange(startDate: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 1).date!, endDate: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 30).date!)

struct GraphicView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ChartView()
                    .frame(width: 1000, height: 300)
            }
        }
    }
}

var data: [AnyEntry] = initData()

struct ChartView: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Chart(data) { data in
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
                        //Text("\(String(format: "%.1fM", data.total/1000000))")
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

struct ChartViewMini: View {
    var body: some View {
        GeometryReader { geometry in
            Chart(data) { data in
                LineMark(
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Money", data.total)
                )
                
            }
            Spacer()
        }
    }
}

func initData() -> [AnyEntry] {
    @State var ExpenseHistory: [Expense] = Expense.sampleData
    @State var IncomeHistory: [Income] = Income.sampleData
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
    return info
}


func dateRange(startDate: Date, endDate: Date) -> [Date] {
    var currentDate = startDate
    var dateArray: [Date] = []
    
    while currentDate <= endDate {
        dateArray.append(currentDate)
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    return dateArray
}
