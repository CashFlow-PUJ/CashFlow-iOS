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
    
    // TODO: Crear lógica de manera que se seleccione un botón y solo para ese botón cambie el color de fondo.
    @State private var categoryIsSelected : Bool = false
    
    @State private var incomeDonutList = [
        [
            ChartData(color: Color(hex: 0xEFF0F2), value: 65),
            ChartData(color: .orange, value: 35)
        ],
    ]
    
    @State private var expenseDonutList = [
        [
            ChartData(color: Color(hex: 0xEFF0F2), value: 65),
            ChartData(color: .orange, value: 35)
        ],
    ]
    
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // TODO: ForEach y agregar 'title' al donutList.
                                
                                // TODO: Wrap a cada miniDonut con un botón.
                                CategoryButton(isSelected: $categoryIsSelected, data: incomeDonutList[0]) {
                                    categoryIsSelected = true
                                }
                                
                                MiniDonut(title: "Regalos", chartData: incomeDonutList[0])
                            }
                        }
                    }
                    else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                MiniDonut(title: "Mercado", chartData: expenseDonutList[0])
                                MiniDonut(title: "Mercado", chartData: expenseDonutList[0])
                                MiniDonut(title: "Mercado", chartData: expenseDonutList[0])
                                MiniDonut(title: "Mercado", chartData: expenseDonutList[0])
                                MiniDonut(title: "Mercado", chartData: expenseDonutList[0])
                            }
                        }
                    }
                    
                    CustomTopTabBar(tabIndex: $secondTabIndex, tabTitles: ["Historial", "Insights"])
                    if secondTabIndex == 0 {
                        
                        // TODO: Vertical Scroll View for Each Transaction
                        
                        if firstTabIndex == 0 {
                            // Display income related history
                            HistoryView(transactionHistory: TransactionHistory.sampleData)
                        }
                        else {
                            // Display expense related history
                            HistoryView(transactionHistory: TransactionHistory.sampleData)
                        }
                    }
                    else {
                        // TODO: Insights View
                        
                        if firstTabIndex == 0 {
                            // Display income related insights
                            Spacer()
                        }
                        else {
                            // Display expense related insights
                            Spacer()
                        }
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
