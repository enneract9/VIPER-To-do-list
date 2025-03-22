//
//  ListInteractor.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol ListInteractor: AnyObject {
    func loadEntities()
    func loadEntities(filter: String?)
    func updateEntity(id: String, completed: Bool)
}

final class ListInteractorImpl: ListInteractor {
    
    weak var presenter: ListPresenter?
    
    private let networkService: NetworkService
    private let coreDataService: CoreDataService
    
    init(networkService: NetworkService = .default, coreDataService: CoreDataService = .default) {
//        #if DEBUG                                                               // TODO: - Убрать?
//        self.networkService = .mock
//        self.coreDataService = .mock
//        #else
        self.networkService = networkService
        self.coreDataService = coreDataService
//        #endif
    }
    
    // MARK: - ListInteractor
    func loadEntities() {
        let isFirstLaunch = false                                                // TODO: - Проверять первая ли загрузка
        
        if isFirstLaunch {
            networkService.fetchEntities(completion: { [weak self] result in
                switch result {
                case .success(let entities):
                    self?.presenter?.interactorDidUpdate(entities: entities)
                    self?.coreDataService.saveEntities(entities)
                case .failure(let error):
                    self?.handle(error: error)
                }
            })
            
            return
        }
        
        coreDataService.fetchEntities(completion: { [weak self] result in
            switch result {
            case .success(let entities):
                self?.presenter?.interactorDidUpdate(entities: entities)
            case .failure(let error):
                self?.handle(error: error)
            }
        })
    }
    
    func loadEntities(filter: String?) {
        coreDataService.fetchEntities(completion: { [weak self] result in
            switch result {
            case .success(let entities):
                guard let filter = filter, !filter.isEmpty else {
                    self?.presenter?.interactorDidUpdate(entities: entities)
                    return
                }
                let entitites = entities.filter {
                    $0.todo.lowercased().contains(filter.lowercased()) ||
                    $0.description?.lowercased().contains(filter.lowercased()) ?? false
                }
                self?.presenter?.interactorDidUpdate(entities: entitites)
            case .failure(let error):
                self?.handle(error: error)
            }
        })
    }
    
    func updateEntity(id: String, completed: Bool) {
        coreDataService.updateEntity(id: id, completed: completed)
        coreDataService.fetchEntities(completion: { [weak self] result in
            switch result {
            case .success(let entities):
                self?.presenter?.interactorDidUpdate(entities: entities)
            case .failure(let error):
                self?.handle(error: error)
            }
        })
    }
    
    private func handle(error: Error) {
        print(String(describing: error))
        // Вызвать алерт в презентаре
    }
}
