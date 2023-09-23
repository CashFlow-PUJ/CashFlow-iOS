//
//  CustomTopTabBar.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/09/23.
//

import SwiftUI

struct CustomTopTabBar: View {
    
    @Binding var tabIndex: Int
    var tabTitles: [String]
    
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(text: tabTitles[0], isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButton(text: tabTitles[1], isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: .black)
        .padding(.top, 5)
        .padding(.horizontal, 10)
        
    }
    
    private func onButtonTapped(index: Int) {
        tabIndex = index
    }
}
