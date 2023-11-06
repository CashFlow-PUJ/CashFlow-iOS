//
//  UserViewModel.swift
//  CashFlow
//
//  Created by Angie Tatiana Peña Peña on 4/11/23.
//

import Foundation

@MainActor class UserViewModel: ObservableObject {
    
    private let getUserByUUID: GetUserByUUID
    private let updateUser: UpdateUser
    private let auth: AuthUser
    
    @Published var user: User?
    
    private let sharedData: SharedData
    private var userLoadTask: Cancellable? { willSet { userLoadTask?.cancel() } }
    private var userUpdateTask: Cancellable? { willSet { userUpdateTask?.cancel() } }
    private var authTask: Cancellable? { willSet { userUpdateTask?.cancel() } }
    
    init(
        sharedData: SharedData,
        getUserByUUID: GetUserByUUID,
        updateUser: UpdateUser,
        auth: AuthUser
    ) {
        self.sharedData = sharedData
        self.getUserByUUID = getUserByUUID
        self.updateUser = updateUser
        self.auth = auth
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
                        self?.user = user
                    }
                case .failure:
                    print("Failed updating user.")
                }
            }
        )
    }
    
    func authenticateUser(userID: String) {
        authTask = auth.execute(
            userID: userID,
            completion: { [weak self] result in
                switch result {
                case .success:
                    print("User is correct")
                case .failure:
                    print("Failed updating user.")
                }
            }
        )
    }
}


