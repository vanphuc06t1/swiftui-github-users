//
//  UserDetailItem.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

struct UserDetailItem: Identifiable, Encodable, Decodable, Hashable {
    
    let id: Int
    let username: String
    let avatarURL: String
    let location: String?
    let followersURL : String
    let followingURL : String
    let blogURL : String
    
    private enum CodingKeys: String, CodingKey {
        case id,
             username = "login",
             avatarURL = "avatar_url",
             location = "location",
             followersURL = "followers_url",
             followingURL = "following_url",
             blogURL = "blog"
    }
}
