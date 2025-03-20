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

final class DefaultCoreDataService: CoreDataService {
    func fetchEntities(completion: @escaping Completion) {
        
    }
}
