//
//  UsersView.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import SwiftUI
import SwiftData

struct UsersView: View {
    
    @Environment(\.modelContext) var modelContext

    @ObservedObject var viewModel : UsersViewModel
    
    private let viewTitle : String = "Github Users"
    
    init(repository: UserItemRepository, service: UserServiceProtocol) {
        _viewModel = ObservedObject(wrappedValue: UsersViewModel(repository: repository, service: service))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.users, id: \.id) { user in
                        ZStack {
                            UserCardView(user: user)
            
                            NavigationLink(destination: UserDetailView(userId: user.id, repository: SwiftDataUserDetailRepository(context: modelContext), service: UserService())) {
                                
                            }
                            .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                        }
                        .onAppear{
                            if user == viewModel.users.last {
                                Task {
                                    await self.loadMoreItems()
                                }
                            }
                        }
                        
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 5)
                                .background(.clear)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 8.0, x: 2, y: 5)
                                .padding(
                                    EdgeInsets(
                                        top: 4,
                                        leading: 12,
                                        bottom: 4,
                                        trailing: 12
                                    )
                                )
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .background(Color.gray.opacity(0.2))
                .listStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSpacing(4)
                .buttonStyle(.borderedProminent)
                .overlay {
                    if viewModel.users.isEmpty {
                        ProgressView()
                    }
                }
                .task {
                    if viewModel.users.isEmpty {
                        Task {
                            await viewModel.loadUsers(page: 1)
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.loadUsers(page: 1)
                    }
                }
            }
            .navigationBarTitle(Text(viewTitle), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func loadMoreItems() async {
        await viewModel.loadMoreUsers()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: UserItemEntity.self, configurations: config)
        let sampleObject = UserItemEntity(item: UserItem(id: 1, username: "Phuc Bui", avatarURL: "https://abc..", githubURL: "https://github.com/vanphuc06t1"))
        container.mainContext.insert(sampleObject)
        
        return UsersView(repository: SwiftDataUserItemRepository(context: container.mainContext), service: UserService()).modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
