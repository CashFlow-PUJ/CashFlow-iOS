//
//  ChartVendorView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 6/11/23.
//
import SwiftUI
import Charts

@available(iOS 17.0, *)
struct VendorView: View {
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        NavigationView{
            VStack{
                let vendorData = calculatePercentageForVendors(sharedData.expenseHistory)
                Chart(vendorData, id: \.name) { vendor in
                    SectorMark(
                        angle: .value(vendor.name, vendor.value),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Vendor", vendor.name))
                }
            }
            .frame(width: 300, height: 300)
        }
    }

    func calculatePercentageForVendors(_ expenses: [Expense]) -> [PieChartDatum] {
        let groupedExpenses = Dictionary(grouping: expenses, by: { $0.vendorName ?? "" })
        let totalExpensesCount = expenses.count

        return groupedExpenses.map { vendor, expenses in
            let percentage = Double(expenses.count) / Double(totalExpensesCount) * 100
            return PieChartDatum(name: vendor, value: percentage)
        }
    }
}


