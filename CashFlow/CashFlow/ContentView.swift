//
//  ContentView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .frame(width: 350, height: 400)
                    .cornerRadius(15)
                
                Spacer()
                
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
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
