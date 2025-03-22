//
//  ListRouter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol ListRouter: AnyObject {
    
}

final class ListRouterImpl {
    weak var presenter: ListPresenter?
}

extension ListRouterImpl: ListRouter {
    
}
