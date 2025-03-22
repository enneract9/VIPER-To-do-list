//
//  ManagedListEntity+CoreDataProperties.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//
//

import Foundation
import CoreData

@objc(ManagedListEntity)
final public class ManagedListEntity: NSManagedObject, Identifiable {
    public static let entityName = "ManagedListEntity"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedListEntity> {
        return NSFetchRequest<ManagedListEntity>(entityName: entityName)
    }

    @NSManaged public var id: String
    @NSManaged public var todo: String
    @NSManaged public var todoDescription: String?
    @NSManaged public var completed: Bool
    @NSManaged public var date: Date
}

extension ManagedListEntity {
    func update(with entity: ListEntity) {
        id = entity.id
        todo = entity.todo
        todoDescription = entity.description
        completed = entity.completed
        date = entity.date
    }
        
    func mapToEntity() -> ListEntity {
        ListEntity(
            id: id,
            todo: todo,
            description: todoDescription,
            completed: completed,
            date: date
        )
    }
}
