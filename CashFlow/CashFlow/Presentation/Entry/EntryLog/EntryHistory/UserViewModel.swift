//
//  UserViewModel.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

@MainActor class UserViewModel: ObservableObject {
    
    private let getUserByUUID: GetUserByUUID
    private let updateUser: UpdateUser  // Paso 1: Inyecta el caso de uso UpdateUser
    
    @Published var user: User?
    
    private let sharedData: SharedData
    private var userLoadTask: Cancellable? { willSet { userLoadTask?.cancel() } }
    private var userUpdateTask: Cancellable? { willSet { userUpdateTask?.cancel() } }  // Mantén un control del task de actualizar
    
    init(
        sharedData: SharedData,
        getUserByUUID: GetUserByUUID,
        updateUser: UpdateUser  // Paso 1: Añade el parámetro para inyectar el caso de uso
    ) {
        self.sharedData = sharedData
        self.getUserByUUID = getUserByUUID
        self.updateUser = updateUser  // Paso 1: Inicializa el caso de uso
    }
    
    func loadUser(uuid: String) {
        userLoadTask = getUserByUUID.execute(
            uuid: uuid,
            completion: { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.user = user
                    }
                case .failure:
                    print("Failed loading user.")
                }
            }
        )
    }
    
    // Paso 2: Método para actualizar el usuario
    func updateUser(uuid: String, user: User, userID: String) {
        let userDTO = UserRequestDTO.fromDomain(user: user)
        userUpdateTask = updateUser.execute(
            uuid: uuid,
            user: userDTO,
            userID: userID,
            completion: { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.user = user  // Actualiza el user en el ViewModel
                    }
                case .failure:
                    print("Failed updating user.")
                }
            }
        )
    }
}


