//
//  ListPresenter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol ListPresenter: AnyObject {
    func viewDidLoad()
    func viewDidSearch(text: String?)
    func viewDidRequestEditor(with presentable: ListViewPresentable?)
    func checkboxValueDidChange(with id: String, newValue: Bool)
    func interactorDidUpdate(entities: [ListEntity])
}

final class ListPresenterImpl {
    weak var view: ListView?
    private var router: ListRouter
    private var interactor: ListInteractor
    
    init(view: ListView? = nil, router: ListRouter, interactor: ListInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ListPresenterImpl: ListPresenter {
    
    // MARK: View -> Presenter
    func viewDidLoad() {
        interactor.loadEntities()
    }
    
    func viewDidSearch(text: String?) {
        interactor.loadEntities(filter: text)
    }
    
    func viewDidRequestEditor(with presentable: ListViewPresentable?) {
        // вызвать роутер
    }
    
    func checkboxValueDidChange(with id: String, newValue: Bool) {
        interactor.updateEntity(id: id, completed: newValue)
    }
    
    // MARK: Interactor -> Presenter
    func interactorDidUpdate(entities: [ListEntity]) {
        let presentables = entities.map {
            ListViewPresentable(
                id: $0.id,
                title: $0.todo,
                description: $0.description,
                checkmarked: $0.completed,
                date: $0.date.formatted(date: .numeric, time: .omitted)
            )
        }
        let title = String(localized: "\(presentables.count) Tasks")
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.update(with: presentables)
            self?.view?.setToolbarTitle(title)
        }
    }
}
