//
//  CollectionPresenter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol CollectionPresenter: AnyObject {
    func viewDidLoad()
    func interactorDidFetch(entities: [TodoEntity])
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
    func viewDidLoad() {
        // начало загрузки данных
        interactor.fetchEntities()
    }
    
    func interactorDidFetch(entities: [TodoEntity]) {
        let presentables = entities.map {
            CollectionViewPresentable(
                title: $0.todo,
                description: $0.description,
                checkmarked: $0.completed,
                date: $0.date
            )
        }
        view?.update(with: presentables)
    }
}
