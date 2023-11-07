//
//  ChartMonthlyViewExpenses.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 6/11/23.
//

import SwiftUI
import Charts

struct GraphicViewExpenses: View {
    
    var expenseData: [AnyEntry]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ChartViewExpenses(expenseData: expenseData)
                    .frame(width: 1000, height: 300)
            }
        }
    }
}

struct ChartViewExpenses: View {
    
    var expenseData: [AnyEntry]
    
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
    
    var expenseData: [AnyEntry]
    
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
    
    var expenseData: [AnyEntry]
    
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
