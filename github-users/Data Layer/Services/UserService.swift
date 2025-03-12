//
//  UserService.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import Foundation
import Combine

protocol UserServiceProtocol {
    func fetchUsers(page: Int) -> Future<[UserItem], Error>
    func fetchUserDetail(userId: Int) -> Future<UserDetailItem, Error>
}

class UserService : UserServiceProtocol {

    
    private let networking : NetworkManager
    
    init(networking: NetworkManager = NetworkManager.shared) {
        self.networking = networking
    }
    
    func fetchUsers(page: Int) -> Future<[UserItem], any Error> {
        return self.networking.getData(endpoint: .users(perpage: page*20, since: 100), type: [UserItem].self)
    }
    
    func fetchUserDetail(userId: Int) -> Future<UserDetailItem, any Error> {
        return self.networking.getData(endpoint: .details(id: userId), type: UserDetailItem.self)
    }
    
    
}
