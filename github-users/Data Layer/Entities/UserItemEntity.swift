//
//  UserItemEntity.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftData

@Model
class UserItemEntity {
    @Attribute(.unique) var id: Int
    var username: String
    var avatarURL: String
    var githubURL : String
    
    init(id: Int, username: String, avatarURL: String, githubURL: String) {
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.githubURL = githubURL
    }
    
    convenience init(item: UserItem) {
        self.init(
            id: item.id,
            username: item.username,
            avatarURL: item.avatarURL,
            githubURL: item.githubURL)
    }
    
}
