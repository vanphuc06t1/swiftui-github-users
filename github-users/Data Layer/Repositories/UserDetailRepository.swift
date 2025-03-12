//
//  UserDetailRepository.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import Foundation
import SwiftData

protocol UserDetailRepository {
    func storeUserDetail(item: UserDetailItem)
    func getUserDetail(userId : Int) -> UserDetailItem?
}

class SwiftDataUserDetailRepository : UserDetailRepository {

    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func storeUserDetail(item: UserDetailItem) {
        let itemToStore = UserDetailItemEntity(item: item)
        context.insert(itemToStore)
    }
    
    func getUserDetail(userId: Int) -> UserDetailItem? {
        let predicate = #Predicate<UserDetailItemEntity>{ $0.id == userId}
        let request = FetchDescriptor<UserDetailItemEntity>(predicate: predicate)
        let data = try? context.fetch(request)
        guard let userDetailEntity = data?.first else {return nil}
        return UserDetailItem(id: userDetailEntity.id,
                              username: userDetailEntity.username,
                              avatarURL: userDetailEntity.avatarURL,
                              location: userDetailEntity.location,
                              followersURL: userDetailEntity.followersURL,
                              followingURL: userDetailEntity.followingURL,
                              blogURL: userDetailEntity.blogURL)
    }
    
    
}
