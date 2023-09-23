//
//  TabBarButton.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/09/23.
//

import SwiftUI

struct TabBarButton: View {
    
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("Avenir", size: 18))
            .padding(.bottom, 10)
            .border(width: isSelected ? 3 : 1, edges: [.bottom], color: Color(hex: 0x828992))
    }
    
}
