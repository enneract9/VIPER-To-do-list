//
//  NetworkService.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol NetworkService {
    typealias Completion = (Result<[TodoEntity], Error>) -> Void
    
    func fetchEntities(completion: @escaping Completion)
}

extension NetworkService where Self == DefaultNetworkService {
    static var `default`: DefaultNetworkService { DefaultNetworkService() }
}

final class DefaultNetworkService: NetworkService {
    enum DefaultNetworkServiceError: Error {
        case invalidURL
    }
    
    private let url = URL(string: "https://dummyjson.com/todos")
    
    func fetchEntities(completion: @escaping Completion) {
        guard let url = url else {
            completion(.failure(DefaultNetworkServiceError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.global(qos: .utility).async {                                 // TODO: QOS?
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.success([]))
                    print("DEBUG: DefaultTodoService | Nil data recieved")
                    return
                }
                
                do {
                    let array = try JSONDecoder().decode(TodoArray.self, from: data)
                    completion(.success(array.todos))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

extension NetworkService where Self == MockNetworkService {
    static var mock: MockNetworkService { MockNetworkService() }
}

final class MockNetworkService: NetworkService {
    func fetchEntities(completion: @escaping Completion) {
        completion(
            .success(TodoEntity.mockEntities)
        )
    }
}
