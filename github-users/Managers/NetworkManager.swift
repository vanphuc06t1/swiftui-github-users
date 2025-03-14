//
//  NetworkManager.swift
//  github-users
//
//  Created by Phuc Bui on 8/2/25.
//

import Foundation
import Combine

enum Endpoint {
    case users(perpage: Int, since: Int)
    case details(id: Int)
    
    var stringValue: String {
        switch self {
        case .users(perpage: let perpage, since: let since):
            return "?per_page=\(perpage)&since=\(since)"
        case .details(id: let id):
            return "/\(id)"
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://api.github.com/users"
    
    
    func getData<T: Decodable>(endpoint: Endpoint, id: Int? = nil, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.stringValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            print("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
    
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
