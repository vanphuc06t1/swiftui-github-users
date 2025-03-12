//
//  UserDetailItem.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftData

@Model
class UserDetailItemEntity {
    @Attribute(.unique) var id: Int
    var username: String
    var avatarURL: String
    var location: String?
    var followersURL: String
    var followingURL: String
    var blogURL : String
    
    init(id: Int, username: String, avatarURL: String, location: String? , followersURL: String, followingURL: String , blogURL: String) {
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.location = location
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.blogURL = blogURL
    }
    
    convenience init(item: UserDetailItem) {
        self.init(
            id: item.id,
            username: item.username,
            avatarURL: item.avatarURL,
            location: item.location,
            followersURL: item.followersURL,
            followingURL: item.followingURL,
            blogURL: item.blogURL)
    }
    
}
