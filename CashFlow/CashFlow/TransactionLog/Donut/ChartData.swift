//
//  ChartData.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 24/09/23.
//

import SwiftUI

struct ChartData: Identifiable {
    var id = UUID()
    // var title: String
    var color : Color
    
    var slicePercent : CGFloat = 0.0
    
    var value : CGFloat
}
