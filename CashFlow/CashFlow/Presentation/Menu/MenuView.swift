//
//  MenuView.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 1/10/23.
//

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

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(imageName) // Usa el nombre de la imagen
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
    
    @Binding  var selectedItem: ItemMenu

    var menuItems: [MenuItem] = ItemMenu.allCases.map { itemMenu in
        return MenuItem(title: itemMenu, systemImageName: itemMenu.symbol) {
            switch itemMenu {
            case .dashboard:
                // Acción al seleccionar Dashboard
                break
            case .rutas:
                // Acción al seleccionar Rutas
                break
            case .configuracion:
                // Acción al seleccionar Configuración
                break
            }
        }
    }

    var body: some View {
        VStack {
            CircularImageButton(action: {
                print("Botón circular tocado")
            }, imageName: "Perfil").padding(.top, 80)
            Text("El usuario")
                .font(.system(size: 20))
                .bold()
                .foregroundColor(.gray)
                .padding(.bottom, 50)
            
            ForEach(menuItems.dropLast()) { menuItem in
                Button(action: {
                    menuItem.action()
                    selectedItem = menuItem.title // Set the selected item
                }) {
                    HStack(spacing: 25) {
                        Image(systemName: menuItem.systemImageName)
                            .resizable()
                            .frame(
                                width: 30,
                                height: 30
                            )
                        Text(menuItem.title.rawValue)
                            .font(.system(size: 20))
                    }
                    .padding(.leading, 40)
                    .frame(
                        width: (UIScreen.main.bounds.width / 2) + 50, 
                        height: 50,
                        alignment: .leading
                    )
                    .background(selectedItem == menuItem.title ? Color(hex: 0xF75E68) : Color.clear)
                    .foregroundColor(selectedItem == menuItem.title ? Color.white : Color.gray)
                }
            }
            
            Spacer()
            
            Button(
                action: {
                    print("Aqui va la Action")
                    selectedItem = menuItems.last!.title
                }
            ){
                HStack(){
                    Image(systemName: menuItems.last!.systemImageName)
                        .resizable()
                        .frame(
                            width: 30,
                            height: 30
                        )
                    Text(menuItems.last!.title.rawValue)
                        .font(.system(size: 20))
                }
                .frame(
                    width: (UIScreen.main.bounds.width / 2) + 10,
                    height: 50,
                    alignment: .leading
                )
                .padding(.leading, 40)
                .background(selectedItem == menuItems.last!.title ? Color(hex: 0xF75E68) : Color.clear)
                .foregroundColor(selectedItem == menuItems.last?.title ? Color.white : Color.gray)
            }
            .padding(.bottom, 20)
            
            
        }
    }
}
