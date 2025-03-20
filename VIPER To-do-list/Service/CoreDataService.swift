//
//  CoreDataService.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol CoreDataService {
    typealias Completion = (Result<[TodoEntity], Error>) -> Void
    
    func fetchEntities(completion: @escaping Completion)
}

extension CoreDataService where Self == DefaultCoreDataService {
    static var `default`: DefaultCoreDataService { DefaultCoreDataService() }
}

final class DefaultCoreDataService: CoreDataService {
    func fetchEntities(completion: @escaping Completion) {
        
    }
}

extension CoreDataService where Self == MockCoreDataService {
    static var mock: MockCoreDataService { MockCoreDataService() }
}

final class MockCoreDataService: CoreDataService {
    func fetchEntities(completion: @escaping Completion) {
        completion(
            .success(TodoEntity.mockEntities)
        )
    }
}
