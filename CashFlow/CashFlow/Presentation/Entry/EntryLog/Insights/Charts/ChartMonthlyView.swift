//
//  ChartMonthlyView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 29/09/23.
//

import SwiftUI
import Charts

let month = Calendar.current.component(.month, from: Date())
let day = Calendar.current.component(.day, from: Date())

let dateRangeArray = dateRange(startDate: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 1).date!, endDate: DateComponents(calendar: Calendar.current, year: 2023, month: month, day: day).date!)

struct GraphicView: View {
    
    var data: [AnyEntry]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ChartView(data: data)
                    .frame(width: 1000, height: 300)
            }
        }
    }
}

struct ChartView: View {
    
    var data: [AnyEntry]
    
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
    
    var data: [AnyEntry]
    
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

func dateRange(startDate: Date, endDate: Date) -> [Date] {
    var currentDate = startDate
    var dateArray: [Date] = []
    
    while currentDate <= endDate {
        dateArray.append(currentDate)
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    return dateArray
}
