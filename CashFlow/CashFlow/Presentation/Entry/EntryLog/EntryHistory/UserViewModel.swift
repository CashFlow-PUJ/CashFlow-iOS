//
//  UserViewModel.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

@MainActor class UserViewModel: ObservableObject {
    
    private let getUserByUUID: GetUserByUUID
    // ... [otros casos de uso relacionados con el usuario, como updateUser, deleteUser, etc.]
    
    @Published var user: User?
    
    private let sharedData: SharedData
    private var userLoadTask: Cancellable? { willSet { userLoadTask?.cancel() } }
    // ... [otros tasks relacionados con el usuario, como userUpdateTask, userDeleteTask, etc.]
    
    init(
        sharedData: SharedData,
        getUserByUUID: GetUserByUUID
        // ... [otros casos de uso inyectados, como updateUser, deleteUser, etc.]
    ) {
        self.sharedData = sharedData
        self.getUserByUUID = getUserByUUID
        // ... [inicializar otros casos de uso]
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
    
    // ... [otros métodos relacionados con el usuario, como updateUser, deleteUser, etc.]
}

