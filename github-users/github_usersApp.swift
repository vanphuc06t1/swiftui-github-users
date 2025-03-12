//
//  github_usersApp.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

import SwiftUI
import SwiftData

@main
struct github_usersApp: App {
    
    @Environment(\.modelContext) var modelContext
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserItemEntity.self,
            UserDetailItemEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        let repository = SwiftDataUserItemRepository(context: sharedModelContainer.mainContext)
        let service = UserService()
        WindowGroup {
            UsersView(repository: repository, service: service)
        }
        .modelContainer(sharedModelContainer)
    }
}
