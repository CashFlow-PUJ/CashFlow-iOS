import SwiftUI
import UIKit

class UserProfile: ObservableObject {
    @Published var profileImage: UIImage?
}

struct EditProfileView: View {
    @EnvironmentObject var userProfile: UserProfile
    @State private var isImagePickerPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Mostrar la imagen de perfil
            Spacer()
            if let image = userProfile.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            }

            Form {
                // Agrega aquí los campos para editar los detalles del perfil
                // Ejemplo:
                Section(header: Text("Información del perfil")) {
                    TextField("Nombre", text: .constant("Juan Pérez")) // Recuerda conectarlo a una variable de estado real
                    TextField("Correo", text: .constant("juan@example.com")) // Lo mismo aquí
                    // Y así sucesivamente para otros campos que necesites
                }
            }
            
            Spacer()
        }
        .navigationTitle("Editar Perfil")
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(selectedImage: $userProfile.profileImage, sourceType: .photoLibrary)
        })
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
