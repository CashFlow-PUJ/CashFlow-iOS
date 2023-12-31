import SwiftUI
import UIKit

class UserProfile: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var name: String?
    @Published var email: String?
    var userId: String?
}

struct EditProfileView: View {
    @EnvironmentObject var userProfile: UserProfile
    @State private var isImagePickerPresented: Bool = false
    @EnvironmentObject var sharedData: SharedData
    @State private var userName: String = ""
    @State private var userLast: String = ""
    @State private var userBirthday: Date = Date()
    @State private var selectedGender: Gender = .male
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
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
                    TextField("Apellido", text: $userLast)
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
            
            Button(action: saveProfileChanges) {
                Text("Guardar Cambios")
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
            
            
            Spacer()
        }
        .onAppear {
            if let user = userViewModel.user {
                userProfile.userId = sharedData.id
                userName = "\(user.firstName)"
                userLast = "\(user.lastName)"
                userBirthday = user.birthDate
                selectedGender = Gender(from: user.gender) ?? .male
                if userProfile.profileImage == nil {
                    userProfile.profileImage = loadImageFromDisk(withName: "userProfileImage\(userProfile.userId ?? "")")
                }
            }
        }
        .navigationTitle("Editar Perfil")
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(selectedImage: $userProfile.profileImage, sourceType: .photoLibrary)
        })
    }
    
    func saveProfileChanges() {
        let updatedUser = User(
            uuid: userViewModel.user?.uuid ?? "",
            birthDate: userBirthday,
            gender: selectedGender.rawValue,
            firstName: userName,
            lastName: userLast
        )
        
        userViewModel.updateUser(uuid: updatedUser.uuid, user: updatedUser, userID: sharedData.userId)
        
        // Verifica si hay un ID de usuario asignado en UserProfile
        if let userId = userProfile.userId, let profileImage = userProfile.profileImage {
            let imageName = "userProfileImage_\(userId)"
            let saved = saveImageToDisk(image: profileImage, withName: imageName)
            if !saved {
                print("Error al guardar la imagen en el dispositivo.")
            }
        }
        
        isPresented = false
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
