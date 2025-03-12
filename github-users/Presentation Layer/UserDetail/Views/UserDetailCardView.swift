//
//  UserDetailCardView.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftUI

///
///Display user card information including image avatar and user information
///
struct UserDetailCardView : View {
    
    //MARK: - properties
    private let user: UserDetailItem

    
    //MARK: - Lifecycles
    init(user: UserDetailItem) {
        self.user = user
    }
    
    var body: some View {
        HStack {
            //Avatar
            VStack(alignment: .leading) {
                ImageView(url: URL(string: user.avatarURL), width: 80.0, height: 80.0, radius: 40.0)
                    .padding(
                        EdgeInsets(
                            top: 4,
                            leading: 12,
                            bottom: 4,
                            trailing: 12
                        )
                    )
            }

            //Information
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.body).fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.top, 2)
                Divider()
                HStack(alignment: .center) {
                    Image(systemName: "location.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                    Text(user.location ?? "N/A")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                }
              }
        }
    }
}

