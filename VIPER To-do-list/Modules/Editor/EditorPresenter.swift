//
//  EditorPresenter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 23.03.2025.
//

import Foundation

protocol EditorPresenter: AnyObject {
    func viewDidLoad()
    func viewWillDisappear(title: String?, description: String?, date: String)
    func interactorDidUpdate(entity: ListEntity?)
}

final class EditorPresenterImpl {
    weak var view: EditorView?
    private var router: EditorRouter
    private var interactor: EditorInteractor
    private let dateFormater: DateFormatter
    
    init(view: EditorView? = nil, router: EditorRouter, interactor: EditorInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yy"
    }
}

extension EditorPresenterImpl: EditorPresenter {
    func viewDidLoad() {
        interactor.loadEntity()
    }
    
    func viewWillDisappear(title: String?, description: String?, date: String) {
        guard title != nil || description != nil else {
            interactor.removeEntity()
            return
        }
        
        guard let date = dateFormater.date(from: date) else {
            return
        }
        
        let todo = (title?.isEmpty ?? true) ? "Задача" : title
        interactor.saveEntity(
            todo: todo ?? "Задача",
            description: description,
            date: date
        )
    }
    
    func interactorDidUpdate(entity: ListEntity?) {
        let presentable = EditorViewPresentable(
            id: entity?.id ?? UUID().uuidString,
            title: entity?.todo,
            description: entity?.description,
            date: dateFormater.string(from: entity?.date ?? Date())
        )
        DispatchQueue.main.async { [weak self] in
            self?.view?.update(with: presentable)
        }
    }
}
