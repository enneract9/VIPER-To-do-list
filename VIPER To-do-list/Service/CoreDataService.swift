//
//  CoreDataService.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit
import CoreData

protocol CoreDataService {
    typealias Completion = (Result<[ListEntity], Error>) -> Void
    
    func fetchEntities(completion: @escaping Completion)
    func updateEntity(id: String, completed: Bool)
    func saveEntities(_ entities: [ListEntity])
    func saveEntity(_ entity: ListEntity)
    func removeEntity(with id: String)
}

// MARK: - Default

extension CoreDataService where Self == DefaultCoreDataService {
    static var `default`: DefaultCoreDataService { DefaultCoreDataService() }
}

final class DefaultCoreDataService: CoreDataService {
    private var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    private var context: NSManagedObjectContext? {
        appDelegate?.persistentContainer.viewContext
    }
    
    func fetchEntities(completion: @escaping Completion) {
        do {
            guard let managedEntities = try context?.fetch(ManagedListEntity.fetchRequest()) else {
                throw DefaultCoreDataServiceError.fetchFailed
            }
            let entities = managedEntities.map { $0.mapToEntity() }
            completion(.success(entities))
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateEntity(id: String, completed: Bool) {
        let request = ManagedListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        let managedEntities = try? context?.fetch(request)
        managedEntities?.forEach { $0.completed = completed }
        
        appDelegate?.saveContext()
    }
    
    func saveEntities(_ entities: [ListEntity]) {
        for entity in entities {
            guard let context = context,
                  let description = NSEntityDescription.entity(forEntityName: ManagedListEntity.entityName, in: context)
            else {
                continue
            }
            
            let request = ManagedListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", entity.id)
            
            let managedEntities = try? context.fetch(request)
            managedEntities?.forEach { context.delete($0) }
            
            let newManagedEntity = ManagedListEntity(entity: description, insertInto: context)
            newManagedEntity.update(with: entity)
        }
        
        appDelegate?.saveContext()
    }
    
    func saveEntity(_ entity: ListEntity) {
        removeEntity(with: entity.id)
        
        guard let context = context,
              let description = NSEntityDescription.entity(forEntityName: ManagedListEntity.entityName, in: context)
        else {
            return
        }
        
        let managedEntity = ManagedListEntity(entity: description, insertInto: context)
        managedEntity.update(with: entity)
        
        appDelegate?.saveContext()
    }
    
    func removeEntity(with id: String) {
        let request = ManagedListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        let managedEntities = try? context?.fetch(request)
        managedEntities?.forEach { context?.delete($0) }
        
        appDelegate?.saveContext()
    }
}

extension DefaultCoreDataService {
    enum DefaultCoreDataServiceError: Error {
        case fetchFailed
    }
}

// MARK: - Mock

extension CoreDataService where Self == MockCoreDataService {
    static var mock: MockCoreDataService { MockCoreDataService() }
}

final class MockCoreDataService: CoreDataService {
    private var entities = ListEntity.mockEntities
    
    func fetchEntities(completion: @escaping Completion) {
        completion(
            .success(entities)
        )
    }
    
    func updateEntity(id: String, completed: Bool) {
        guard var entity = entities.first(where: { $0.id == id }) else {
            return
        }
        entities.removeAll(where: { $0.id == id })
        entity.completed = completed
        entities.append(entity)
    }
    
    func saveEntities(_ entities: [ListEntity]) {
        entities.forEach { removeEntity(with: $0.id) }
        self.entities.append(contentsOf: entities)
    }
    
    func saveEntity(_ entity: ListEntity) {
        if let index = entities.firstIndex(where: { $0.id == entity.id }) {
            entities.remove(at: index)
        }
        entities.append(entity)
    }
    
    func removeEntity(with id: String) {
        if let index = entities.firstIndex(where: { $0.id == id }) {
            entities.remove(at: index)
        }
    }
}
