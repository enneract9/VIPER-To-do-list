//
//  CollectionModuleBuilder.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

final class CollectionModuleBuilder {
    static func build() -> UIViewController {
        let router = CollectionRouterImpl()
        let interactor = CollectionInteractorImpl()
        let view = CollectionViewImpl()
        let presenter = CollectionPresenterImpl(router: router, interactor: interactor)
        
        router.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
}
