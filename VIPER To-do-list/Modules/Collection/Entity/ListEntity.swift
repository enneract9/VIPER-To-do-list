//
//  ListEntity.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

struct ListEntity: Codable {
    let id: String
    var todo: String
    var description: String?
    var completed: Bool
    let date: Date
    
    init(
        id: String = UUID().uuidString,
        todo: String,
        description: String? = nil,
        completed: Bool,
        date: Date = Date()
    ) {
        self.id = id
        self.todo = todo
        self.description = description
        self.completed = completed
        self.date = date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = String(try container.decode(Int.self, forKey: .id))
        self.todo = try container.decode(String.self, forKey: .todo)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.date = (try container.decodeIfPresent(Date.self, forKey: .date)) ?? Date()
    }
}

extension ListEntity {
    static let mockEntities: [ListEntity] = [
        ListEntity(
            todo: "Do something nice for someone you care about Do something nice for someone you care about Do something nice for someone you care about",
            description: "Do something nice for someone you care about Do something nice for someone you care about Do something nice for someone you care about",
            completed: false
        ),
        ListEntity(
            todo: "Contribute code or a monetary donation to an open-source software project",
            description: nil,
            completed: true
        ),
        ListEntity(
            todo: "Watch a documentary",
            description: "Write a thank you letter to an influential person in your life",
            completed: true
        )
    ]
}

struct TodoArray: Codable {
    let todos: [ListEntity]
}
