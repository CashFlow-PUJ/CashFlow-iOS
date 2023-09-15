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
    
    // @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                /*
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 400)
                    .cornerRadius(15)
                 */
                
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
                
                //Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            // ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            ImageInputViewControllerRepresentable()
        }
    }
}

struct ImageInputViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ImageInputViewController()
        return vc
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
