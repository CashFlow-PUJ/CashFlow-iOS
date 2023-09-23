//
//  TransactionLogView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 28/08/23.
//

import SwiftUI

struct TransactionLogView: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var image: UIImage?
    
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
                                Image(systemName: "camera.fill")
                                    .renderingMode(.original)
                                    .foregroundColor(.primary)
                                    .font(.title)
                            }
                        )
                        
                        Text("Registro")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // TODO: TabView for Expenses and Income
                    TabView {
                        // TODO: Horizontal Scroll View for Donuts
                        // TODO: Donut component
                    }
                    
                    // TODO: TabView for History and Insight
                    TabView {
                        // TODO: Vertical Scroll View for Each Transaction
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

struct TransactionLog_Previews: PreviewProvider {
    static var previews: some View {
        TransactionLogView()
    }
}
