//
//  VendorCharts.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 7/11/23.
//

import SwiftUI
import Charts

@available(iOS 17.0, *)
struct VendorChartsView: View {
    
    var vendorData: [PieChartDatum]
    
    // View Properties
    @State private var graphType: GraphType = .donut
    
    // Chart selection
    @State private var barSelection: String?
    @State private var pieSelection: Double?
    
    var body: some View {
    
        VStack{
            Picker("", selection: $graphType){
                ForEach(GraphType.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            
            ZStack{
                
                if let highestValues = vendorData.max(by: {
                    $1.value > $0.value
                }){
                    if graphType == .bar {
                        ChartPopOverView(highestValues.value, highestValues.name, true)
                            .opacity(barSelection == nil ? 1 : 0)
                    }else{
                        if let barSelection, let selectedValues = vendorData.findValues(barSelection){
                            ChartPopOverView(selectedValues, barSelection, true, true)
                        }else{
                            
                            ChartPopOverView(highestValues.value, highestValues.name, true)
                        }
                    }
                    
                }
                
            }
            .padding(.vertical)
            
            Chart {
                ForEach(vendorData) { value in
                    if graphType == .bar{
                        BarMark(
                        
                            x: .value("Vendedor", value.name),
                            y: .value("Total", value.value)
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Vendedor", value.name))
                        .foregroundStyle(Color.blue.gradient)
                        
                    }else {
                        SectorMark(
                            angle: .value("Total", value.value),
                            innerRadius: .ratio(graphType == .donut ? 0.61 : 0),
                            angularInset: graphType == .donut ? 6 : 1
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Vendedor", value.name))
                        .opacity(barSelection == nil ? 1 : (barSelection == value.name ? 1 : 0.4))
                    }
                    
                }
                
                if let barSelection{
                    RuleMark(x: .value("Vendedor", barSelection))
                        .foregroundStyle(.gray.opacity(0.035))
                        .zIndex(-10)
                        .offset(yStart: -10)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit, y: .disabled)){
                                if let values = vendorData.findValues(barSelection){
                                    ChartPopOverView(values, barSelection)
                                }
                            }
                    
                }
            }
            .chartXSelection(value: $barSelection)
            .chartAngleSelection(value: $pieSelection)
            .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
            .frame(height: 300)
            .padding(.top, 15)
            .animation(graphType == .bar ? .none : .snappy, value: graphType)
            Spacer(minLength: 0)
        }
        .padding()
        .onChange(of: pieSelection, initial: false) {oldValue, newValue in
            
            if let newValue{
                findTotal(newValue)
            }else{
                barSelection = nil
            }
            
        }
    }
    
    // Chart Popover View
    @ViewBuilder
    func ChartPopOverView(_ values: Double, _ vendedor: String, _ isTitleView: Bool = false, _ isSelection: Bool = false ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(isTitleView && !isSelection ? "Mayor" : "Total") Vendedor")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4){
                Text(String(format: "%0.0f", values) + "%")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(vendedor)
                    .font(.title3)
                    .textScale(.secondary)
            }
            
        }
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(Color(.white).opacity(isTitleView ? 0 : 1), in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity,maxHeight: 250, alignment: isTitleView ? .leading : .center)
    }
    
    func findTotal(_ rangeValue: Double){
        // Converting download model into Array of Tuples
        var initialValue: Double = 0.0
        let convertedArray = vendorData
            .sorted(by: {$0.value > $1.value})
            .compactMap{download -> (String, Range<Double>) in
            let rangeEnd = initialValue + download.value
            let tuple = (download.name, initialValue ..< rangeEnd)
            initialValue = rangeEnd
            
            return tuple
        }
        
        if let download = convertedArray.first(where: {
            $0.1.contains(rangeValue)
        }){
            barSelection = download.0
        }
    }
    
}




