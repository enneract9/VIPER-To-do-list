//
//  CollectionPresenter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol CollectionPresenter: AnyObject {
    func viewDidLoaded()
    func entitiesDidFetched(entities: [TodoEntity])
}

final class CollectionPresenterImpl {
    weak var view: CollectionView?
    private var router: CollectionRouter
    private var interactor: CollectionInteractor
    
    init(view: CollectionView? = nil, router: CollectionRouter, interactor: CollectionInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension CollectionPresenterImpl: CollectionPresenter {
    func viewDidLoaded() {
        
    }
    
    func entitiesDidFetched(entities: [TodoEntity]) {
        
    }
}
