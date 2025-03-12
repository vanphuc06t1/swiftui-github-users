//
//  github_usersDetailViewModelTests.swift
//  github-users
//
//  Created by Phuc Bui on 11/2/25.
//

import Combine
import XCTest

@testable import github_users

class MockUserDetailRepository: UserDetailRepository {
    
    func getUserDetail(
        userId: Int
    ) -> github_users.UserDetailItem? {
        return  github_users.UserDetailItem.init(
            id: 1,
            username: "Phuc Bui",
            avatarURL: "https://github.com/vanphuc06t1",
            location: "Vietnam",
            followersURL: "https://github.com/vanphuc06t1",
            followingURL: "https://github.com/vanphuc06t1",
            blogURL: "https://github.com/vanphuc06t1"
        )
    }
    
    func storeUserDetail(item: github_users.UserDetailItem) {
        
    }
    
}

class MockUserDetailRepository_NilData: UserDetailRepository {
    
    func getUserDetail(
        userId: Int
    ) -> github_users.UserDetailItem? {
        return nil
    }
    
    func storeUserDetail(item: github_users.UserDetailItem) {
        
    }
    
}


class UsersDetailViewModelTests: XCTestCase {
    
    var mockService: UserServiceProtocol!
    var mockUserDetailRepository: UserDetailRepository!
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockUserService()
        mockUserDetailRepository = MockUserDetailRepository()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        mockService = nil
        mockUserDetailRepository = nil
        super.tearDown()
    }
    
    func testGetUserDetail_UsesMockService() async {
        //Given
        let viewModel = UserDetailViewModel(
            repository: mockUserDetailRepository,
            service: mockService
        )
        
        //When
        let expectation = XCTestExpectation(
            description: "User detail should loaded"
        )
        
        viewModel.$userDetail
            .sink { value in
                expectation
                    .fulfill()
            }
            .store(
                in: &cancellables
            )
        
        await viewModel.getUserDetail(userId: 123)
        
        wait(
            for: [expectation],
            timeout: 1.0
        )
        
        //Then
        XCTAssertEqual(
            viewModel.userDetail,
            github_users.UserDetailItem.init(
                id: 1,
                username: "Phuc Bui",
                avatarURL: "https://github.com/vanphuc06t1",
                location: "Vietnam",
                followersURL: "https://github.com/vanphuc06t1",
                followingURL: "https://github.com/vanphuc06t1",
                blogURL: "https://github.com/vanphuc06t1"
            ),
            "ViewModel should load mock data user detail"
        )
    }
    
    func testGetUserDetailNilData_UsesMockService() async {
        //Given
        let mockUserDetailRepository_NilData = MockUserDetailRepository_NilData()
        let viewModel = UserDetailViewModel(
            repository: mockUserDetailRepository_NilData,
            service: mockService
        )
        
        //When
        let expectation = XCTestExpectation(
            description: "User detail should return value"
        )
        
        viewModel.$userDetail
            .sink { value in
                expectation
                    .fulfill()
            }
            .store(
                in: &cancellables
            )
        
        await viewModel.getUserDetail(userId: 123)
        
        wait(
            for: [expectation],
            timeout: 1.0
        )
        
        //Then
        XCTAssertEqual(
            viewModel.userDetail,
            github_users.UserDetailItem.init(
                id: 1,
                username: "Phuc Bui",
                avatarURL: "https://github.com/vanphuc06t1",
                location: "Vietnam",
                followersURL: "https://github.com/vanphuc06t1",
                followingURL: "https://github.com/vanphuc06t1",
                blogURL: "https://github.com/vanphuc06t1"
            ),
            "ViewModel should return mock data user detail"
        )
    }
    
    func testFetchUserDetail_UsesMockService() async {
        //Given
        let mockUserDetailRepository_NilData = MockUserDetailRepository_NilData()
        let viewModel = UserDetailViewModel(
            repository: mockUserDetailRepository_NilData,
            service: mockService
        )

        await viewModel.getUserDetail(userId: 123)
        
        let expectation = XCTestExpectation(
            description: "User detail should return value"
        )
        
        viewModel.$userDetail
            .sink { value in
                expectation
                    .fulfill()
            }
            .store(
                in: &cancellables
            )
        
        wait(
            for: [expectation],
            timeout: 1.0
        )
        
        //Then
        XCTAssertEqual(
            viewModel.userDetail,
            github_users.UserDetailItem.init(
                id: 1,
                username: "Phuc Bui",
                avatarURL: "https://github.com/vanphuc06t1",
                location: "Vietnam",
                followersURL: "https://github.com/vanphuc06t1",
                followingURL: "https://github.com/vanphuc06t1",
                blogURL: "https://github.com/vanphuc06t1"
            ),
            "ViewModel should return for mock data user detail"
        )
        
    }
}
