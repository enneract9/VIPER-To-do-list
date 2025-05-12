//
//  EditorView.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//

import UIKit

protocol EditorView: AnyObject {
    func update(with presentable: EditorViewPresentable)
}

final class EditorViewImpl: UIViewController {
    
    var presenter: EditorPresenter?
    private let contentView: EditorContentView = EditorContentView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.viewWillDisappear(
            title: contentView.titleText,
            description: contentView.descriptionText,
            date: contentView.date
        )
    }
}

extension EditorViewImpl: EditorView {
    func update(with presentable: EditorViewPresentable) {
        contentView.titleText = presentable.title
        contentView.date = presentable.date
        contentView.descriptionText = presentable.description
    }
}
