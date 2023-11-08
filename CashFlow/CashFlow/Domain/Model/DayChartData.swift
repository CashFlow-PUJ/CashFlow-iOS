//
//  DayChartData.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 7/11/23.
//

import Foundation

struct DayChartData: Identifiable {
    var id = UUID().uuidString
    var hours : Date
    var views : Double
    var animated : Bool = false
}

extension Date{
    func updateHours(value: Int)->Date{
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

var sample_analytics : [DayChartData] = []
