//
//  UserItemRepository.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftData

protocol UserItemRepository {
    func getUsers(page : Int) -> [UserItem]
    func storeUsers(users: [UserItem])
}

class SwiftDataUserItemRepository : UserItemRepository {
    
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
    
    func getUsers(page: Int) -> [UserItem] {
        do {
            let descriptor = FetchDescriptor<UserItemEntity>(predicate: nil, sortBy: [.init(\.id)])
            let results = try context.fetch(descriptor)
            //transform
            let users = results.map { UserItem(id: $0.id, username: $0.username, avatarURL: $0.avatarURL, githubURL: $0.githubURL) }
            return Array(users.prefix(page*20))
        } catch {
            print("Error fetch users")
            return []
        }
    }
    
    func storeUsers(users: [UserItem]) {
        do {
            let descriptor = FetchDescriptor<UserItemEntity>(predicate: nil, sortBy: [.init(\.id)])
            let results = try context.fetch(descriptor)
            let uniqueValues = Set(results.map { $0[keyPath: \.id] })
            
            for item in users {
                if (uniqueValues.contains(item.id)) {
                    ///skip duplicate insertion
                    continue
                }
                ///Insert new one
                let itemToStore = UserItemEntity(item: item)
                context.insert(itemToStore)
            }
        } catch {
            print("Error store users")
        }
    }

    
}
