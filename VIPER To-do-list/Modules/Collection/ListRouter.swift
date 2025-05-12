//
//  ListRouter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

protocol ListRouter: AnyObject {
    func showEditor(entityId: String?)
}

final class ListRouterImpl {
    weak var viewController: UIViewController?
}

extension ListRouterImpl: ListRouter {
    func showEditor(entityId: String?) {
        let editorModule = EditorModuleBuilder.build(entityId: entityId)
        viewController?.navigationController?.pushViewController(editorModule, animated: true)
    }
}
