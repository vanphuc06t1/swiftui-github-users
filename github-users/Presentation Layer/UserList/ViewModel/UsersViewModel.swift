//
//  UserListViewModel.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

import Foundation
import Combine
import SwiftData

//MARK: - ViewModel Protocol
protocol UsersViewModelProtocol : AnyObject {
    func loadUsers(page: Int) async
    func loadMoreUsers() async
}

//MARK: - ViewModel
@MainActor
class UsersViewModel: UsersViewModelProtocol, ObservableObject {
    
    //MARK: - States
    @Published var users: [UserItem] = []
    @Published var page : Int = 1
    
    @Published var isLoading = false
    
    //MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let repository: UserItemRepository
    private let service: UserServiceProtocol
    
    //MARK: - Lifecycles
    init(repository: UserItemRepository, service: UserServiceProtocol) {
        self.repository = repository
        self.service = service
    }
    
    //MARK: - Public functions
    func loadUsers(page: Int) async {
        let users = repository.getUsers(page: page)
    
        if (users.count >= page * 20) {
            DispatchQueue.main.async {
                self.isLoading = false
                self.users = users
            }
            return
        }
        await fetchUsers(page: page)
    }
    
    func loadMoreUsers() async {
        guard !isLoading else { return }
        DispatchQueue.main.async {
            self.isLoading = true
            self.inscreasePage()
        }
        
        await loadUsers(page: self.page)
    }
    
    
    //MARK: - Private functions
    private func inscreasePage() {
        self.page += 1
    }
    
    func fetchUsers(page: Int) async {
        self.service.fetchUsers(page: page)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error fetch github user list: \(err.localizedDescription)")
                    //Handle UI for fetching failed
                    self.isLoading = false
                case .finished:
                    print("Finished fetch github user list")
                    self.isLoading = false
                }
            }
        receiveValue: {[weak self] users in
            guard let self else {return}
            //print("users: \(users)")
            DispatchQueue.main.async {
                self.repository.storeUsers(users: users)
                //Get again latest users
                let users = self.repository.getUsers(page: page)
                self.users = users
            }
            
        }
        .store(in: &cancellables)
    }

    
}

