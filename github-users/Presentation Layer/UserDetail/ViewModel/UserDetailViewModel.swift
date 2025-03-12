//
//  UserDetailViewModel.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import Foundation
import Combine
import SwiftData

//MARK: - User Detail ViewModel Protocol
protocol UserDetailViewModelProtocol : AnyObject {
    func getUserDetail(userId: Int)
}

//MARK: - User Detail ViewModel
@MainActor
class UserDetailViewModel : UserDetailViewModelProtocol, ObservableObject {

    //MARK: - States
    @Published var userDetail : UserDetailItem?
    
    //MARK: - Properties
    private let repository: UserDetailRepository
    private let service: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: - Lifecycles
    init(repository: UserDetailRepository, service: UserServiceProtocol) {
        self.repository = repository
        self.service = service
    }
    
    func getUserDetail(userId: Int) {
        //Load user detail from database
        if let user = repository.getUserDetail(userId: userId) {
            self.userDetail = user
        } else {
            //If not existed then fetch from url
            service.fetchUserDetail(userId: userId)
                .sink { completion in
                    switch completion {
                    case .failure(let err):
                        print("Fetch User Detail Error: \(err.localizedDescription)")
                    case .finished:
                        print("Fetch User Detail Finished")
                    }
                }
            receiveValue: {[weak self] userDetailDTO in
                
                DispatchQueue.main.async {
                    self?.repository.storeUserDetail(item: userDetailDTO)
                    self?.userDetail = userDetailDTO
                }
                
            }
            .store(in: &cancellables)
        }
        
    }
    

    
}
