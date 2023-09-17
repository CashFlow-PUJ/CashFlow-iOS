//
//  ContentView.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 23/07/23.
//

import SwiftUI

struct ImageInputView: View {
    
    // TODO: Find out how to remove 'Back' button in NavigationStack routed view.
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    // TODO: Remove the following lines once Sign Out dedicated trigger is implemented.
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var vm = AuthViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                // TODO: Remove this button once Sign Out dedicated trigger is implemented.
                Button(
                    action: {
                        vm.signOut()
                        coordinator.path = coordinator.path.dropLast()
                    },
                    label: {
                        Text("Sign Out")
                            .font(.title)
                    }
                )
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker){
            ImageInputViewControllerRepresentable()
        }
    }
}

struct ImageInputViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "IIVC")
                return viewController
    }
    
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInputView()
    }
}
