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
        ChartView(data: data)
            .frame(width: 333, height: 400)
        Spacer()
    }
}

struct ChartView: View {
    
    var data: [AnyEntry]
    
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.5),
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.2),
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.05),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        VStack {
            GroupBox {
                GeometryReader { geometry in
                    Chart(data) { data in
                        
                        LineMark(
                            x: .value("Day", data.date, unit: .day),
                            y: .value("Money", data.total)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
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
                        .interpolationMethod(.catmullRom)
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
            }
            .groupBoxStyle(YellowGroupBoxStyle())
        }
    }
}

struct ChartViewMini: View {
    
    var data: [AnyEntry]
    
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.5),
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.2),
                Color(hue: 0.33, saturation: 0.81, brightness: 0.76).opacity(0.05),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                Chart(data) { data in
                    LineMark(
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Money", data.total)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    
                    AreaMark(
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Money", data.total)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(curGradient)
                }
                Spacer()
            }
        }
        .frame(width: 333)
        .groupBoxStyle(YellowGroupBoxStyle())
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
