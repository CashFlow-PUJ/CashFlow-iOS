//
//  ContentView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI

struct ImageInputView: View {
        
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    // TODO: Remove the following lines once Sign Out dedicated trigger is implemented.
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var vm = AuthViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                Spacer()
                
                Button(
                    action: {
                        self.showImagePicker = true
                    },
                    label: {
                        Image(systemName: "camera.fill")
                            .renderingMode(.original)
                            .foregroundColor(.primary)
                            .font(.title)
                })
                
                Spacer()
                
                // TODO: Remove this button once Sign Out dedicated trigger is implemented.
                Button(
                    action: {
                        vm.signOut()
                        coordinator.path.append(.login)
                    },
                    label: {
                        Text("Sign Out")
                            .font(.title)
                    }
                )
                
                Spacer()
                Spacer()
                
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker){
            ImageInputViewControllerRepresentable()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInputView()
    }
}
