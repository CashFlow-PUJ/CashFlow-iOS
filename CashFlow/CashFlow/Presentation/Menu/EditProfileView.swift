import SwiftUI
import UIKit

class UserProfile: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var name: String?
    @Published var email: String?
}

struct EditProfileView: View {
    @EnvironmentObject var userProfile: UserProfile
    @State private var isImagePickerPresented: Bool = false
    
    @State private var userName: String = ""
    @State private var userLast: String = ""
    @State private var userBirthday: Date = Date()
    
    @State private var selectedGender: Gender = .male
    
    @EnvironmentObject var userViewModel: UserViewModel
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
                
                Section(header: Text("Nombre")) {
                    TextField("Nombre", text: $userName)
                }
                
                Section(header: Text("Apellido")) {
                    TextField("Nombre", text: $userLast)
                }
                
                Section(header: Text("Género")) {
                    Picker("Género", selection: $selectedGender) {
                        Text(Gender.male.displayName).tag(Gender.male)
                        Text(Gender.female.displayName).tag(Gender.female)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Fecha de nacimiento")) {
                    DatePicker("Selecciona tu fecha de nacimiento", selection: $userBirthday, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
            }
            
            Spacer()
        }
        .onAppear {
           if let user = userViewModel.user {
               userName = "\(user.firstName)"
               userLast = "\(user.lastName)"
               userBirthday = user.birthDate
               selectedGender = Gender(from: user.gender) ?? .male
               if userProfile.profileImage == nil {
                   userProfile.profileImage = loadImageFromDisk(withName: "userProfileImage")
               }
           }
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
                let saved = saveImageToDisk(image: image, withName: "userProfileImage")
                if !saved {
                    print("Error al guardar la imagen en el dispositivo.")
                }
            }
            picker.dismiss(animated: true)
        }
    }
}

// Funciones de ayuda para guardar y cargar imágenes en el dispositivo
func saveImageToDisk(image: UIImage, withName name: String) -> Bool {
    guard let data = image.pngData() else { return false }
    let filename = getDocumentsDirectory().appendingPathComponent("\(name).png")
    do {
        try data.write(to: filename)
        return true
    } catch {
        print("Error guardando la imagen: \(error.localizedDescription)")
        return false
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func loadImageFromDisk(withName name: String) -> UIImage? {
    let filename = getDocumentsDirectory().appendingPathComponent("\(name).png")
    do {
        let data = try Data(contentsOf: filename)
        return UIImage(data: data)
    } catch {
        print("Error cargando la imagen: \(error.localizedDescription)")
        return nil
    }
}
