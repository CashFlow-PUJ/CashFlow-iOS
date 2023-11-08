//
//  ChartDailyView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 7/11/23.
//

import SwiftUI
import Charts

struct ChartDailyView: View {
    @EnvironmentObject var sharedData: SharedData

    @State var currentTab: DailyChartEnum = .all

    @State var data: [DayChartData] = sample_analytics

    @State var currentActiveItem : DayChartData?
    @State var plotWidth: CGFloat = 0
        
    @State var isLineGraph: Bool = false
    
    var body: some View {
            NavigationView{
                VStack{
                    VStack(alignment: .leading, spacing: 12){
                        HStack{
                            Text("Total")
                                .fontWeight(.semibold)
                            
                            Picker("", selection: $currentTab){
                                ForEach(DailyChartEnum.allCases, id: \.rawValue) { type in
                                    Text(type.rawValue)
                                        .tag(type)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.segmented)
                            .padding(.leading, 40)
                        }
                        
                        let totalValue = data.reduce(0.0) { partialResult, item in
                            item.views + partialResult
                        }
                        
                        Text(totalValue.stringFormat)
                            .font(.largeTitle.bold())
                        
                        AnimatedChart()
                        
                        Toggle("Line Graph", isOn: $isLineGraph)
                            .padding(.top)
                            .foregroundStyle(.red)
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white.shadow(.drop(radius: 2)))
                    }
                    
                }
                .padding()
                
                .onChange(of: currentTab) { newValue in
                    switch newValue {
                        case .all:
                            data = sample_analytics
                        case .day:
                            data = getToday()
                        case .week:
                            data = getWeek()
                        case .month:
                            data = getMonth()
                    }
                    animateGraph(fromChange: true)
                }

            }
        
        
        }
    
    @ViewBuilder
    func AnimatedChart()->some View {
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
        
        let max = data.max{ item1, item2 in
            return item2.views > item1.views
        }?.views ?? 0
        
        Chart{
            ForEach(data){ item in
                if isLineGraph{
                    LineMark(x: .value("Hours", item.hours,unit: .hour),
                            y: .value("Views",item.animated ? item.views : 0)
                    )
                    .interpolationMethod(.catmullRom(alpha: 0.75))
                    .foregroundStyle(.red.gradient)

                    
                }else{
                    switch currentTab {
                    case .all:
                        BarMark(x: .value("Days", item.hours, unit: .day),
                                y: .value("Views",item.animated ? item.views : 0)
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom(alpha: 0.75))
                    case .day:
                        BarMark(x: .value("Hours", item.hours, unit: .hour),
                                y: .value("Views",item.animated ? item.views : 0)
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom(alpha: 0.75))
                    case .week:
                        BarMark(x: .value("Days", item.hours, unit: .day),
                                y: .value("Views",item.animated ? item.views : 0)
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom(alpha: 0.75))
                    case .month:
                        BarMark(x: .value("Days", item.hours, unit: .day),
                                y: .value("Views",item.animated ? item.views : 0)
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom(alpha: 0.75))
                    }
                    
                }
                
                if isLineGraph{
                    AreaMark(x: .value("Hours", item.hours,unit: .hour),
                            y: .value("Views",item.animated ? item.views : 0)
                    )
                    .interpolationMethod(
                        .catmullRom(alpha: 0.75)
                    )
                    .foregroundStyle(curGradient)

                }
                
                if let currentActiveItem,currentActiveItem.id == item.id {
                    RuleMark(x: .value("Hour", currentActiveItem.hours))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .offset(x: (plotWidth / CGFloat(data.count)) / 2 )
                        .annotation(position: .top){
                            VStack(alignment: .leading, spacing: 6){
                                Text("Views")
                                    .font(.caption)
                                
                                Text(currentActiveItem.views.stringFormat)
                                    .font(.title3.bold())
                                
                            }
                            .padding(.horizontal,10)
                            .padding(.vertical,4)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                                
                            }
                        }
                }
            }
        }
        .chartYScale(domain: 0...(max))
        .chartOverlay(content: { proxy in
            GeometryReader{innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onEnded{value in
                                let location = value.location
                                
                                if let date: Date = proxy.value(atX: location .x){
                                    
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    
                                    if let currentItem = data.first(where: { item in
                                        calendar.component(.hour, from: item.hours) == hour
                                    })
                                    {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                                
                            }
                            .onEnded{value in
                                self.currentActiveItem = nil
                            }
                    )
                
            }
            
        })

        .frame(height: 150)
        .onAppear{
            animateGraph()
        }
    }
    
    func getToday() -> [DayChartData] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let recordsForToday = sample_analytics.filter { record in
            return calendar.isDate(record.hours, inSameDayAs: currentDate)
        }
        
        let sortedRecords = recordsForToday.sorted { $0.hours < $1.hours }
        
        return sortedRecords
    }
    
    func getWeek() -> [DayChartData] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
            return []
        }
        
        let recordsForLastWeek = sample_analytics.filter { record in
            return calendar.isDate(record.hours, equalTo: oneWeekAgo, toGranularity: .day) || calendar.isDate(record.hours, equalTo: currentDate, toGranularity: .day)
        }
        
        let sortedRecords = recordsForLastWeek.sorted { $0.hours < $1.hours }
        return sortedRecords
    }
    
    
    func getMonth() -> [DayChartData] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) else {
            return []
        }
        let recordsForLastMonth = sample_analytics.filter { record in
            return calendar.isDate(record.hours, equalTo: oneMonthAgo, toGranularity: .month) || calendar.isDate(record.hours, equalTo: currentDate, toGranularity: .month)
        }
        
        let sortedRecords = recordsForLastMonth.sorted { $0.hours < $1.hours }
        
        return sortedRecords
    }
    
    func animateGraph(fromChange: Bool = false){
        for (index,_) in data.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)){
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)){
                    data[index].animated = true
                }
            }
        }
    }
}

//MARK: Extention To Convert Double To String With K,M Number Values

extension Double{
    var stringFormat : String {
        if self >= 10000 && self < 999999{
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999{
            return String(format: "%.2fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)

            
    }
}
