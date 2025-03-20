//
//  CollectionInteractor.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol CollectionInteractor: AnyObject {
    func fetchEntities()
}

final class CollectionInteractorImpl: CollectionInteractor {
    weak var presenter: CollectionPresenter?
    
    private let networkService: NetworkService
    private let coreDataService: CoreDataService
    
    init(networkService: NetworkService = .default, coreDataService: CoreDataService = .default) {
        #if DEBUG                                                               // TODO: - Убрать?
        self.networkService = .mock
        self.coreDataService = .mock
        #else
        self.networkService = networkService
        self.coreDataService = coreDataService
        #endif
    }
    
    // MARK: - CollectionInteractor
    func fetchEntities() {
        let isFirstLaunch = true                                                // TODO: - Проверять первая ли загрузка
        
        if isFirstLaunch {
            networkService.fetchEntities(completion: { [weak self] result in
                switch result {
                case .success(let entities):
                    self?.presenter?.interactorDidFetch(entities: entities)
                    // CoreData                                                 // TODO: Сохранить в кордату
                case .failure(let error):
                    self?.handle(error: error)
                }
            })
            
            return
        }
        
        // CoreData ...
    }
    
    private func handle(error: Error) {
        print(String(describing: error))
        // Вызвать алерт в презентаре
    }
}
