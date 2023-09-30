//
//  TotalCustomView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 29/09/23.
//

import SwiftUI

struct TotalCustomView: View {
    
    var title : String

    @State var chartData : [ChartData]
    
    @State private var selectedSlice = 1
    
    var body: some View {
        VStack {
            
            Text(title)
                .font(.headline)
                .foregroundColor(Color(hex: 0xABB5BE))
            
            ZStack {
                
                ForEach(0 ..< chartData.count, id:\.self) { index in
                    Circle()
                        .trim(from: index == 0 ? 0.0 : chartData[index-1].slicePercent,
                              to: chartData[index].slicePercent)
                        .stroke(chartData[index].color, lineWidth: 7.5)
                }
                
                if selectedSlice != -1 {
                    Text(String(format: "$%.1fM", Double(chartData[selectedSlice].total / 1000000)))
                        .font(.system(size: 16))
                        .foregroundColor(chartData.last?.color)
                }
                
            }
            .frame(width: 75, height: 93.75)
        }
        .onAppear {
            setupChartData()
        }
        .padding()
    }
    
    private func setupChartData() {
        let total : CGFloat = chartData.reduce(0.0) { $0 + $1.value }
        
        for i in 0..<chartData.count {
            let percentage = (chartData[i].value / total)
            chartData[i].slicePercent =  (i == 0 ? 0.0 : chartData[i - 1].slicePercent) + percentage
        }
    }
}

