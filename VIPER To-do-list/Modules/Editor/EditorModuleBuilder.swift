//
//  EditorModuleBuilder.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//

import UIKit

final class EditorModuleBuilder {
    static func build(entityId: String?) -> UIViewController {
        let router = EditorRouterImpl()
        let interactor = EditorInteractorImpl(entityId: entityId)
        let view = EditorViewImpl()
        let presenter = EditorPresenterImpl(router: router, interactor: interactor)
        
        router.viewController = view
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
}
