//
//  UserCardView.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftUI

struct UserCardView : View {
    
    //MARK: - properties
    private let user: UserItem

    
    //MARK: - Lifecycles
    init(user: UserItem) {
        self.user = user
    }
    
    var body: some View {
        HStack {
            //Avatar
            VStack(alignment: .leading) {
                ImageView(url: URL(string: user.avatarURL), width: 80.0, height: 80.0, radius: 40.0)
            }
            .frame(width: 80, height: 80, alignment: .center)
            //Information
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.body).fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.top, 2)
                Divider()
                Text(user.githubURL)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 6
                    )            }
        }
      
    }
}

