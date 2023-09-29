//
//  MonthlyView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 28/09/23.
//

import SwiftUI

struct MonthlyView: View {
    @State private var showChart = false

    var body: some View {
        NavigationView{
            VStack{
                ChartViewMini()
                    .frame(width: 390, height: 230, alignment: .center)
                    .opacity(showChart ? 0.0 : 1.0)
                    
                NavigationLink{
                    GraphicView()
                    Spacer()
                }label: {
                    Text("Ver Informe Mensual")
                }
                Spacer()
            }
        }
    }
}

#Preview {
    MonthlyView()
}
