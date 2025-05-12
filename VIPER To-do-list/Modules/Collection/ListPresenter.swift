//
//  ListPresenter.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import Foundation

protocol ListPresenter: AnyObject {
    func viewWillAppear()
    func viewDidSearch(text: String?)
    func viewDidRemovePresentable(id: String)
    func viewDidRequestEditor(entityId: String?)
    func checkboxValueDidChange(entityId: String, newValue: Bool)
    func interactorDidUpdate(entities: [ListEntity])
}

final class ListPresenterImpl {
    weak var view: ListView?
    private var router: ListRouter
    private var interactor: ListInteractor
    private let dateFormater: DateFormatter
    
    init(view: ListView? = nil, router: ListRouter, interactor: ListInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yy"
    }
}

extension ListPresenterImpl: ListPresenter {
    
    // MARK: View -> Presenter
    func viewWillAppear() {
        interactor.loadEntities()
    }
    
    func viewDidSearch(text: String?) {
        interactor.loadEntities(filter: text)
    }
    
    func viewDidRemovePresentable(id: String) {
        interactor.removeEntity(id: id)
    }
    
    func viewDidRequestEditor(entityId: String?) {
        router.showEditor(entityId: entityId)
    }
    
    func checkboxValueDidChange(entityId: String, newValue: Bool) {
        interactor.updateEntity(id: entityId, completed: newValue)
    }
    
    // MARK: Interactor -> Presenter
    func interactorDidUpdate(entities: [ListEntity]) {
        let presentables = entities
            .sorted(by: { $0.date > $1.date })
            .map {
                ListViewPresentable(
                    id: $0.id,
                    title: $0.todo,
                    description: $0.description,
                    checkmarked: $0.completed,
                    date: dateFormater.string(from: $0.date)
                )
            }
        let title = String(localized: "\(presentables.count) Tasks")
        
        let animatingDifferences = presentables.count != view?.presentablesCount
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.update(with: presentables, animatingDifferences: animatingDifferences)
            self?.view?.setToolbarTitle(title)
        }
    }
}
