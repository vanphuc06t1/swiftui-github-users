//
//  github_usersServiceTests.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//
import XCTest
import Combine
@testable import github_users


class UserServiceTests: XCTestCase {
    
    var userService: UserServiceProtocol!
    var cancellables: Set<AnyCancellable>!
    var networking : NetworkManager!
    
    override func setUp() {
        super.setUp()
        networking = NetworkManager.shared
        userService = UserService(networking: networking)
        cancellables = []
    }

    override func tearDown() {
        userService = nil
        cancellables = nil
        networking = nil
        super.tearDown()
    }
    
    func testFetchUsers_Success() {
        let expectation = XCTestExpectation(description: "Future should return success")
        
        let future = Future<[github_users.UserItem], any Error> { promise in
            promise(.success([
                github_users.UserItem(id: 1, username: "Phuc Bui", avatarURL: "https://github.com/vanphuc06t1", githubURL: "https://github.com/vanphuc06t1"),
                github_users.UserItem(id: 2, username: "Mobile", avatarURL: "https://github.com/vanphuc06t1", githubURL: "https://github.com/vanphuc06t1")]))
        }
  
        future
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { value in
                XCTAssertEqual(value, [
                    github_users.UserItem(id: 1, username: "Phuc Bui", avatarURL: "https://github.com/vanphuc06t1", githubURL: "https://github.com/vanphuc06t1"),
                    github_users.UserItem(id: 2, username: "Mobile", avatarURL: "https://github.com/vanphuc06t1", githubURL: "https://github.com/vanphuc06t1")])
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsers_Failure() {
        let expectation = XCTestExpectation(description: "Future should return failure")
        
        let future = Future<[github_users.UserItem], any Error> { promise in
            promise(.failure(NetworkError.responseError))
        }
        
        future
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as! NetworkError, NetworkError.responseError )
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but received value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
}
