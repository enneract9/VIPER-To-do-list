//
//  ListModuleBuilder.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

final class ListModuleBuilder {
    static func build() -> UIViewController {
        let router = ListRouterImpl()
        let interactor = ListInteractorImpl()
        let view = ListViewImpl()
        let presenter = ListPresenterImpl(router: router, interactor: interactor)
        
        router.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
}
