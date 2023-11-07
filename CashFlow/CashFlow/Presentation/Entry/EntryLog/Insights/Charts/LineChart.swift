//
//  LineChart.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 7/11/23.
//

import SwiftUI

struct LineChartView: View {
    
    @EnvironmentObject var sharedData: SharedData
    @State private var linearDataType: LinearDataTime = .one
    
    var body: some View {
        
        VStack {
            Picker("", selection: $linearDataType){
                ForEach(LinearDataTime.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            
            switch linearDataType {
            case .one:
                EmptyView()
            case .dos:
                MonthlyViewExpenses()
                    .padding(.top, 15)
                    .environmentObject(sharedData)
            }
            
        }
        .padding()
    }
}
