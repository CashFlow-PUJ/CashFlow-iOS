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
        
        VStack {
            
            HStack {
                // TODO: Hamburger menu button
                Text("Registro")
                    .font(.title)
            }
            
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
        
        /*
        NavigationView {
            
            // TODO: View where to place, store and show the image to get user feedback: Was the image good quality? Want to take another one? etc.
            Image(uiImage: image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 400)
                .cornerRadius(15)
            
            // TODO: Turn this Button into a Floating Button (Screen-fixed, Z-axis)
            Button(
                action: {
                    self.showSheet = true
                },
                label: {
                    Image(systemName: "camera.fill")
                        .renderingMode(.original)
                        .foregroundColor(.primary)
                        .font(.title)
            })
            .actionSheet(isPresented: $showSheet) {
                ActionSheet(
                    title: Text("Escanear recibo"),
                    message: Text("Seleccione una foto"),
                    buttons: [
                        .default(Text("Galería")) {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        },
                        .default(Text("Cámara")) {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        },
                        .cancel(Text("Cancelar"))
                    ]
                )
            }
            
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
        */
    }
}

struct TransactionLog_Previews: PreviewProvider {
    static var previews: some View {
        TransactionLogView()
    }
}
