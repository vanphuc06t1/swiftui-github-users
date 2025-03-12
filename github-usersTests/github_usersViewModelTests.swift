//
//  github_usersViewModelTests.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

import Combine
import XCTest

@testable import github_users

class MockUserService: UserServiceProtocol {
    func fetchUsers(page: Int) -> Future<[github_users.UserItem],any Error> {
        return Future<[github_users.UserItem],any Error> { promise in
            promise(
                .success(
                    [
                        github_users
                            .UserItem(
                                id: 1,
                                username: "Phuc Bui",
                                avatarURL: "https://github.com/vanphuc06t1",
                                githubURL: "https://github.com/vanphuc06t1"
                            ),
                        github_users
                            .UserItem(
                                id: 2,
                                username: "Mobile",
                                avatarURL: "https://github.com/vanphuc06t1",
                                githubURL: "https://github.com/vanphuc06t1"
                            ),
                    ]
                )
            )
        }
    }

    func fetchUserDetail(userId: Int) -> Future<github_users.UserDetailItem, any Error> {
        return Future<github_users.UserDetailItem,any Error> { promise in
            promise(
                .success(
                    github_users.UserDetailItem.init(
                        id: 1,
                        username: "Phuc Bui",
                        avatarURL: "https://github.com/vanphuc06t1",
                        location: "Vietnam",
                        followersURL: "https://github.com/vanphuc06t1",
                        followingURL: "https://github.com/vanphuc06t1",
                        blogURL: "https://github.com/vanphuc06t1"
                    )
                )
            )
        }
    }

}

class MockUserItemRepository: UserItemRepository {

    func getUsers(page: Int) -> [github_users.UserItem] {
        return [
            github_users
                .UserItem(
                    id: 1,
                    username: "Phuc Bui",
                    avatarURL: "https://github.com/vanphuc06t1",
                    githubURL: "https://github.com/vanphuc06t1"
                ),
            github_users
                .UserItem(
                    id: 2,
                    username: "Mobile",
                    avatarURL: "https://github.com/vanphuc06t1",
                    githubURL: "https://github.com/vanphuc06t1"
                ),
        ]
    }

    func storeUsers(users: [github_users.UserItem]) {

    }

}

class MockEmptyUserItemRepository: UserItemRepository {

    func getUsers(page: Int) -> [github_users.UserItem] {
        return []
    }

    func storeUsers(users: [github_users.UserItem]) {

    }

}

class MockUserServiceFailed: UserServiceProtocol {
    func fetchUsers(page: Int) -> Future<[github_users.UserItem],any Error> {
        return Future<[github_users.UserItem], any Error> { promise in
            promise(.failure(NetworkError.responseError))
        }
    }

    func fetchUserDetail(userId: Int) -> Future<github_users.UserDetailItem, any Error> {
        return Future<github_users.UserDetailItem, any Error> { promise in
            promise(.failure(NetworkError.responseError))
        }
    }

}

class UsersViewModelTests: XCTestCase {

    var mockService: UserServiceProtocol!
    var mockUserItemRepository: UserItemRepository!

    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        mockService = MockUserService()
        mockUserItemRepository = MockUserItemRepository()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        mockService = nil
        mockUserItemRepository = nil
        super.tearDown()
    }

    func testMockUserService_fetchUsers() {
        let expectation = XCTestExpectation(
            description: "Future should return success"
        )
        let testUsers = [
            github_users
                .UserItem(
                    id: 1,
                    username: "Phuc Bui",
                    avatarURL: "https://github.com/vanphuc06t1",
                    githubURL: "https://github.com/vanphuc06t1"
                ),
            github_users
                .UserItem(
                    id: 2,
                    username: "Mobile",
                    avatarURL: "https://github.com/vanphuc06t1",
                    githubURL: "https://github.com/vanphuc06t1"
                ),
        ]

        let future = mockService.fetchUsers(page: 1)

        future
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail(
                            "Expected success but got failure"
                        )
                    }
                },
                receiveValue: { value in
                    XCTAssertEqual(
                        value,
                        testUsers
                    )
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testMockUserService_fetchUserDetail() {
        let expectation = XCTestExpectation(
            description: "Future should return success"
        )
        let testUserDetail = github_users.UserDetailItem.init(
            id: 1,
            username: "Phuc Bui",
            avatarURL: "https://github.com/vanphuc06t1",
            location: "Vietnam",
            followersURL: "https://github.com/vanphuc06t1",
            followingURL: "https://github.com/vanphuc06t1",
            blogURL: "https://github.com/vanphuc06t1"
        )

        let future = mockService.fetchUserDetail(userId: 1)

        future
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail(
                            "Expected success but got failure"
                        )
                    }
                },
                receiveValue: { value in
                    XCTAssertEqual(
                        value,
                        testUserDetail
                    )
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadUsers_UsesMockService() async {
        //Given
        let mockUserItemRepository = MockUserItemRepository()
        let viewModel = UsersViewModel(
            repository: mockUserItemRepository,
            service: mockService
        )
        let testUsers = [
            github_users
                .UserItem(
                    id: 1,
                    username: "Phuc Bui",
                    avatarURL: "https://github.com/vanphuc06t1",
                    githubURL: "https://github.com/vanphuc06t1"
                ),
            github_users
                .UserItem(
                    id: 2,
                    username: "Mobile",
                    avatarURL: "https://github.com/vanphuc06t1",
                    githubURL: "https://github.com/vanphuc06t1"
                ),
        ]

        //When
        let expectation = XCTestExpectation(
            description: "Load users should return value"
        )

        await viewModel.loadUsers(page: 1)

        viewModel.$users
            .sink { value in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation],timeout: 2.0)

        //Then
        XCTAssertEqual(
            viewModel.users,
            testUsers,
            "ViewModel should load mock data"
        )
    }

    func testLoadUsersEmptyInSwiftData_UsesMockService() async {
        //Given
        let mockEmptyUserItemRepository = MockEmptyUserItemRepository()

        let viewModel = UsersViewModel(
            repository: mockEmptyUserItemRepository,
            service: mockService
        )

        //When
        await viewModel.loadUsers(page: 1)

        //Then
        XCTAssertEqual(
            viewModel.users,
            [],
            "ViewModel should load mock data"
        )

    }

    func testLoadMoreUsers_UsesMockService() async {
        //Given
        let viewModel = UsersViewModel(
            repository: mockUserItemRepository,
            service: mockService
        )

        //When
        await viewModel.loadMoreUsers()

        let expectation = XCTestExpectation(
            description: "Page should be increase"
        )
        var receivedValues: [Int] = []

        viewModel.$page
            .sink { value in
                receivedValues
                    .append(
                        value
                    )
                if receivedValues.count == 2 {  // Initial value + one increment
                    expectation.fulfill()
                }
            }
            .store(
                in: &cancellables
            )


        wait(for: [expectation],timeout: 1.0)

        //Then
        XCTAssertEqual(
            viewModel.page,
            2,
            "Page should be increase"
        )

    }

    func testLoadUsersFailed_UsesMockServiceFailed() async {
        //Given
        let mockUserServiceFailed = MockUserServiceFailed()
        let viewModel = UsersViewModel(
            repository: mockUserItemRepository,
            service: mockUserServiceFailed
        )

        //When
        let expectation = XCTestExpectation(
            description: "Page should be increase"
        )

        viewModel.$users
            .sink { value in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.fetchUsers(page: 1)
        await viewModel.loadUsers(page: 1)

        wait(for: [expectation],timeout: 2.0)

        //Then
        XCTAssertEqual(
            viewModel.users,
            [],
            "ViewModel should load mock data with empty data due to service failed"
        )
    }

}
