import Combine
import SwiftData
//
//  UserDetailView.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftUI

struct UserDetailView: View {

    //MARK: - Properties
    @ObservedObject private var viewModel: UserDetailViewModel

    private var userId: Int

    private let viewTitle: String = "User Details"

    init(
        userId: Int, repository: UserDetailRepository,
        service: UserServiceProtocol
    ) {
        _viewModel = ObservedObject(
            wrappedValue: UserDetailViewModel(
                repository: repository, service: service))
        self.userId = userId
    }

    var body: some View {

        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if let userDetail = viewModel.userDetail {
                        //User Detail Card
                        UserDetailCardView(user: userDetail)
                            .frame(height: 100, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .background(.clear)
                                    .foregroundColor(.white)
                                    .shadow(
                                        color: .gray, radius: 8.0, x: 2, y: 5
                                    )

                            )
                        //Follower, Following
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                VStack(alignment: .center) {
                                    Image(systemName: "person.2.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("100+")
                                        .font(.subheadline).fontWeight(.bold)
                                        .foregroundColor(Color.gray)
                                    Text("Follower")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                VStack(alignment: .center) {
                                    Image(systemName: "person.2.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text("10+")
                                        .font(.subheadline).fontWeight(.bold)
                                        .foregroundColor(Color.gray)
                                    Text("Following")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        //Blog information
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Blog")
                                    .font(.title3).fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                Text("\(String(describing: userDetail.blogURL.isEmpty == true ? "N/A" : userDetail.blogURL))")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding(.top, 8)

                    } else {
                        ProgressView()
                    }
                }

                .padding(
                    EdgeInsets(
                        top: 4,
                        leading: 12,
                        bottom: 4,
                        trailing: 12
                    ))
            }
          
        }
       
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle(Text(viewTitle), displayMode: .inline)
        .onAppear {
            viewModel.getUserDetail(userId: userId)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: UserItemEntity.self, configurations: config)
        let sampleObject = UserItemEntity(
            item: UserItem(
                id: 1, username: "Phuc Bui", avatarURL: "https://abc..",
                githubURL: "https://github.com/vanphuc06t1"))
        container.mainContext.insert(sampleObject)

        return UserDetailView(
            userId: 117,
            repository: SwiftDataUserDetailRepository(
                context: container.mainContext), service: UserService()
        ).modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }

}
