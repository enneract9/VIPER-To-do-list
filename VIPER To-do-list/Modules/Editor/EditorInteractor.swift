//
//  EditorInteractor.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//

import Foundation

protocol EditorInteractor: AnyObject {
    func loadEntity()
    func saveEntity(todo: String, description: String?, date: Date)
    func removeEntity()
}

final class EditorInteractorImpl {
    weak var presenter: EditorPresenter?
    let coreDataService: CoreDataService
    
    private let entityId: String?
    private var entity: ListEntity?
    
    init(entityId: String?, coreDataService: CoreDataService = .default) {
        self.entityId = entityId
        self.coreDataService = coreDataService
    }
}

extension EditorInteractorImpl: EditorInteractor {
    func loadEntity() {
        guard let id = entityId else {
            presenter?.interactorDidUpdate(entity: nil)
            return
        }
        
        coreDataService.fetchEntity(id: id, completion: { [weak self] result in
            switch result {
            case .success(let entity):
                self?.presenter?.interactorDidUpdate(entity: entity)
                self?.entity = entity
            case .failure(let error):
                self?.handle(error: error)
            }
        })
    }
    
    func saveEntity(todo: String, description: String?, date: Date) {
        let completed = entity?.completed ?? false
        let entity = ListEntity(
            id: entityId ?? UUID().uuidString,
            todo: todo,
            description: description,
            completed: completed,
            date: date
        )
        self.entity = entity
        coreDataService.saveEntities([entity])
    }
    
    func removeEntity() {
        if let id = entityId {
            coreDataService.removeEntity(id: id)
        }
    }
    
    private func handle(error: Error) {
        print(String(describing: error))
        // Вызвать алерт в презентаре
    }
}
