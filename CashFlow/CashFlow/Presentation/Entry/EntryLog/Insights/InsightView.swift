//
//  InsightExpense.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 6/11/23.
//
import SwiftUI

@available(iOS 17.0, *)
struct InsightExpenseView: View {
    @EnvironmentObject var sharedData: SharedData
    var body: some View {
        let vendorData = calculatePercentageForVendors(sharedData.expenseHistory)
        ScrollView {
            VStack {
                LineChartView()
                    .environmentObject(sharedData)
                
                VendorChartsView(vendorData: vendorData)
                    .environmentObject(sharedData)
            }
        }
    }
    
    func calculatePercentageForVendors(_ expenses: [Expense]) -> [PieChartDatum] {
        let groupedExpenses = Dictionary(grouping: expenses, by: { $0.vendorName ?? "" })
        let totalExpensesCount = expenses.count

        return groupedExpenses.map { vendor, expenses in
            let percentage = Double(expenses.count) / Double(totalExpensesCount) * 100
            let totalExpenses = expenses.reduce(into: 0.0) { $0 += Double($1.total) }
            return PieChartDatum(name: vendor, value: percentage, total: totalExpenses)
        }
    }
}
