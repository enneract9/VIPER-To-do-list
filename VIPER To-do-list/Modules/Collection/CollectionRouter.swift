//
//  CollectionRouter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol CollectionRouter: AnyObject {
    
}

final class CollectionRouterImpl {
    weak var presenter: CollectionPresenter?
}

extension CollectionRouterImpl: CollectionRouter {
    
}
