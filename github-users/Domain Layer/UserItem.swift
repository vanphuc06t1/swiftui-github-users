//
//  UserItem.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

struct UserItem: Identifiable, Encodable, Decodable, Hashable {
    
    let id: Int
    let username: String
    let avatarURL: String
    let githubURL : String
    
    private enum CodingKeys: String, CodingKey {
        case id,
             username = "login",
             avatarURL = "avatar_url",
             githubURL = "html_url"
    }
}

