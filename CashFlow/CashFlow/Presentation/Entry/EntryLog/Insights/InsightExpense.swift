//
//  InsightExpense.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 6/11/23.
//

import Foundation
import SwiftUI

struct InsightExpense: View {
    @State private var graphType: GraphType = .bar
    var body: some View {
        VStack {
            Section(header: Text("Seleccione el Gráfico")) {
                Picker("", selection: $graphType) {
                    ForEach(GraphType.allCases, id: \.rawValue) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                Spacer(minLength: 0)
                
            }
        }
    }
}
