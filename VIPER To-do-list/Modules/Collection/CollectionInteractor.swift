//
//  CollectionInteractor.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol CollectionInteractor: AnyObject {
    func fetchData()
}

final class CollectionInteractorImpl {
    weak var presenter: CollectionPresenter?
}

extension CollectionInteractorImpl: CollectionInteractor {
    func fetchData() {
//        [weak self] in self?.presenter?.dataDidFetched()
    }
}
