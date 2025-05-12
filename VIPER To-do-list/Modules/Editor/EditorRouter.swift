//
//  EditorRouter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//

import UIKit

protocol EditorRouter: AnyObject { }

final class EditorRouterImpl {
    weak var viewController: UIViewController?
}

extension EditorRouterImpl: EditorRouter { }
