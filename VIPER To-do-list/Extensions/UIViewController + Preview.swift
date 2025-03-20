//
//  UIViewController + Preview.swift
//  VIPER To-do-list
//
//  Created by @_@ on 21.03.2025.
//

import UIKit
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }

    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
