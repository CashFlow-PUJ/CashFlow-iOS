import SwiftUI

struct MenuItem: Identifiable, Equatable {
    var id = UUID()
    let title: ItemMenu
    let systemImageName: String
    let action: () -> Void

    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CircularImageButton: View {
    var action: () -> Void
    var imageName: String
    @Binding var isTapped: Bool

    var body: some View {
        Button(action: {
            action()
            isTapped = true
        }) {
            Image(imageName)
                .resizable()
                .frame(
                    width:  (UIScreen.main.bounds.width / 2) - 100,
                    height: (UIScreen.main.bounds.width / 2) - 100
                )
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}

struct MenuView: View {
    @State private var isMenuOpen = false
    @State private var isPhotoOpen = false
    
    @State private var showEditProfile: Bool = false
    @State private var showLogView: Bool = false
    
    @Binding var selectedItem: ItemMenu
    @EnvironmentObject var userProfile: UserProfile
    
    @StateObject private var authVM = AuthViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var sharedData: SharedData
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        let menuItems: [MenuItem] = ItemMenu.allCases.map { itemMenu in
            return MenuItem(title: itemMenu, systemImageName: itemMenu.symbol) {
                navigate()
            }
        }
        
        return NavigationView {
            VStack {
                if let image = userProfile.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 100, height: (UIScreen.main.bounds.width / 2) - 100)
                        .clipShape(Circle())
                        .padding(.top, 80)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 100, height: (UIScreen.main.bounds.width / 2) - 100)
                        .padding(.top, 80)
                }
                
                Text(userViewModel.user?.firstName ?? "Nombre de usuario")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)
                
                ForEach(menuItems.dropLast()) { menuItem in
                    Button(action: {
                        selectedItem = menuItem.title
                        menuItem.action()
                    }) {
                        HStack(spacing: 25) {
                            Image(systemName: menuItem.systemImageName)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(menuItem.title.rawValue)
                                .font(.system(size: 20))
                        }
                        .padding(.leading, 40)
                        .frame(width: (UIScreen.main.bounds.width / 2) + 50, height: 50, alignment: .leading)
                        .background(selectedItem == menuItem.title ? Color(hex: 0xF75E68) : Color.clear)
                        .foregroundColor(selectedItem == menuItem.title ? Color.white : Color.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    selectedItem = menuItems.last!.title
                    menuItems.last!.action()
                }) {
                    HStack {
                        Image(systemName: menuItems.last!.systemImageName)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(menuItems.last!.title.rawValue)
                            .font(.system(size: 20))
                    }
                    .frame(width: (UIScreen.main.bounds.width / 2) + 10, height: 50, alignment: .leading)
                    .padding(.leading, 40)
                    .background(selectedItem == menuItems.last!.title ? Color(hex: 0xF75E68) : Color.clear)
                    .foregroundColor(selectedItem == menuItems.last?.title ? Color.white : Color.gray)
                }
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(isPresented: $showEditProfile)
                    .environmentObject(userViewModel)
                    .environmentObject(userProfile)
                    .environmentObject(sharedData)
            }
            .navigationDestination(isPresented: $showLogView, destination: {
                EntryLogView(coordinator: coordinator, sharedData: sharedData)
                    .preferredColorScheme(.light)
                    .navigationBarBackButtonHidden(true)
            })
            .onAppear {
                userViewModel.loadUser(uuid: sharedData.userId)
            }
        }
    }
    
    func navigate() {
        switch selectedItem {
            case .dashboard:
                showLogView = true
            case .configuracion:
                showEditProfile = true
            case .cerrarSesion:
                authVM.signOut()
                sharedData.userId = ""
                coordinator.currentRoute = .login
                break
        }
    }
}
