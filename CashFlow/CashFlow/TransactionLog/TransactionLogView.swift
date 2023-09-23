//
//  TransactionLogView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 28/08/23.
//

import SwiftUI

struct TransactionLogView: View {
    
    // ImageInput
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?

    @State var firstTabIndex = 0
    @State var secondTabIndex = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    HStack {
                        Button(
                            action: {
                                // TODO: Show Lateral Menu
                            },
                            label: {
                                Image(systemName: "text.justify")
                                    .renderingMode(.original)
                                    .foregroundColor(Color(hex: 0xF75E68))
                                    .font(.title)
                            }
                        )
                        .padding(.horizontal, 10)
                        
                        Text("Registro")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    CustomTopTabBar(tabIndex: $firstTabIndex, tabTitles: ["Ingresos", "Gastos"])
                    if firstTabIndex == 0 {
                        // TODO: Horizontal Scroll View for Donuts (Expenses)
                        // TODO: Donut component
                        Spacer()
                    }
                    else {
                        // TODO: Horizontal Scroll View for Donuts (Income)
                        Spacer()
                    }
                    
                    CustomTopTabBar(tabIndex: $secondTabIndex, tabTitles: ["Historial", "Insights"])
                    if secondTabIndex == 0 {
                        // TODO: Vertical Scroll View for Each Transaction
                        Spacer()
                    }
                    else {
                        // TODO: Insights View
                        Spacer()
                    }
                    
                }
                .padding()
                
                Button(
                    action: {
                        self.showImagePicker = true
                    },
                    label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color(hex: 0xF75E68))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                )
                .padding(.all, 25)
            }
        }
        .sheet(isPresented: $showImagePicker){
            ImageInputViewControllerRepresentable()
        }
    }    
}
