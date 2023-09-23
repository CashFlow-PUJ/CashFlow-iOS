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
    
    // TabBarButton
    @Binding var tabIndex: Int
    
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
                    
                    HStack {
                        
                        Spacer()
                        TabBarButton(text: "Ingresos", isSelected: .constant(tabIndex == 0))
                            .onTapGesture { onButtonTapped(index: 0) }
                        
                        Spacer()
                        
                        TabBarButton(text: "Gastos", isSelected: .constant(tabIndex == 1))
                            .onTapGesture { onButtonTapped(index: 1) }
                        Spacer()
                    }
                    .border(width: 1, edges: [.bottom], color: .black)
                    .padding(.top, 5)
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    /*
                    // TODO: TabView for Expenses and Income
                    TabView {
                        // TODO: Horizontal Scroll View for Donuts
                        // TODO: Donut component
                    }
                    
                    // TODO: TabView for History and Insight
                    TabView {
                        // TODO: Vertical Scroll View for Each Transaction
                    }
                    */
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
    
    private func onButtonTapped(index: Int) {
        tabIndex = index
    }
}
