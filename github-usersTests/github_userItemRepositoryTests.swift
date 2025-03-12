//
//  github_userItemRepositoryTests.swift
//  github-users
//
//  Created by Phuc Bui on 9/2/25.
//

import XCTest
import SwiftData
@testable import github_users


class UserItemRepositoryTests: XCTestCase {
    
    var userItemRepository: UserItemRepository!
    var container: ModelContainer!

    override func setUp() {
        super.setUp()
        do {
            let schema = Schema([UserItemEntity.self])
            let config = ModelConfiguration(isStoredInMemoryOnly: true) // In-memory for testing
            self.container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        let context = ModelContext(container)
        userItemRepository = SwiftDataUserItemRepository(context: context)
    }

    override func tearDown() {
        userItemRepository = nil
        container = nil
        super.tearDown()
    }
    
    func testGetUsers() async throws {
        userItemRepository.storeUsers(users: [UserItem(id: 1, username: "Phuc Bui", avatarURL: "https://github.com/vanphuc06t1", githubURL: "https://github.com/vanphuc06t1")])
        let users = userItemRepository.getUsers(page: 1)

        XCTAssertEqual(users.count, 1, "User count should be 1 after adding a user")
        XCTAssertEqual(users.first?.username, "Phuc Bui", "User name should match")
        XCTAssertEqual(users.first?.githubURL, "https://github.com/vanphuc06t1", "User github URL should match")
    }
}
