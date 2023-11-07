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
        ChartViewExpenses(expenseData: expenseData)
            .frame(width: 360, height: 400)
        Spacer()
    }
}

struct ChartViewExpenses: View {
    
    var expenseData: [AnyEntry]
    
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                Color(.red).opacity(0.5),
                Color(.red).opacity(0.2),
                Color(.red).opacity(0.05),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        VStack {
            GroupBox ("Gastos") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        GeometryReader { geometry in
                            Chart(expenseData) { data in
                                LineMark(
                                    x: .value("Day", data.date, unit: .day),
                                    y: .value("Money", data.total)
                                )
                                .interpolationMethod(
                                    .catmullRom(alpha: 0.75)
                                )
                                .foregroundStyle(
                                    .red
                                )
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                
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
                                
                                AreaMark(
                                    x: .value("Day", data.date, unit: .day),
                                    y: .value("Money", data.total)
                                )
                                .interpolationMethod(
                                    .catmullRom(alpha: 0.75)
                                )
                                .foregroundStyle(curGradient)
                                
                            }
                            .navigationTitle("Informe Mensual")
                            .chartXAxis{
                                AxisMarks(values: .stride(by: .day)){ day in
                                    AxisValueLabel(format: .dateTime.day(.defaultDigits))
                                    AxisGridLine()
                                }
                            }
                        }
                        .frame(width: 666)
                    }
                }
            }
            .groupBoxStyle(YellowGroupBoxStyle())
        }
    }
}

struct ChartViewExpensesMini: View {
    
    var expenseData: [AnyEntry]
    
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                Color(.red).opacity(0.5),
                Color(.red).opacity(0.2),
                Color(.red).opacity(0.05),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                Chart(expenseData) { data in
                    LineMark(
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Money", data.total)
                    )
                    .interpolationMethod(
                        .catmullRom(alpha: 0.75)
                    )
                    .foregroundStyle(
                        .red
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    
                    AreaMark(
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Money", data.total)
                    )
                    .interpolationMethod(
                        .catmullRom(alpha: 0.75)
                    )
                    .foregroundStyle(curGradient)
                }
            }
        }
        .frame(width: 333)
        .groupBoxStyle(YellowGroupBoxStyle())
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
        }
    }
}

struct YellowGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(20)
            .background(Color(hue: 0.10, saturation: 0.10, brightness: 0.98))
            .cornerRadius(20)
            .overlay(
                configuration.label.padding(15),
                alignment: .top
            )
    }
}
