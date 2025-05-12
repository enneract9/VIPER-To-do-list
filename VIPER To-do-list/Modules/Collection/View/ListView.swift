//
//  CollectionController.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

protocol ListView: AnyObject {
    var presentablesCount: Int { get }
    func update(with presentables: [ListViewPresentable], animatingDifferences: Bool)
    func setToolbarTitle(_ text: String)
}

class ListViewImpl: UIViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ListViewPresentable>?
    
    var presenter: ListPresenter?
    var presentablesCount: Int {
        dataSource?.snapshot().numberOfItems ?? 0
    }
    
    private let tableView: UITableView = UITableView()
    private lazy var dataSource: DataSource = createDataSource()
    private lazy var searchController: UISearchController = createSearchController()        // TODO: Поиск голосом
    
    override func loadView() {
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    private func setup() {
        title = "Задачи"
        
        configureTableView()
        configureNavigation()
    }
    
    private func configureTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: ListCellConfiguration.reuseId
        )
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .label.withAlphaComponent(0.5)
        tableView.separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    private func configureNavigation() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.searchController = searchController
        toolbarItems = createToolbarItems()
        
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .secondarySystemBackground
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .yellow
    }
 
    private func createDataSource() -> DataSource {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, presentable in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListCellConfiguration.reuseId)
            cell?.contentConfiguration = ListCellConfiguration(
                presentable: presentable,
                checkboxDidToggle: { [weak self] value in
                    self?.presenter?.checkboxValueDidChange(entityId: presentable.id, newValue: value)
                }
            )
            cell?.selectionStyle = .none
            return cell
        }
    }
    
    private func createSearchController() -> UISearchController {
        definesPresentationContext = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }
    
    private func createToolbarItems() -> [UIBarButtonItem] {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let countLabel = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        countLabel.isEnabled = false
        countLabel.setTitleTextAttributes(
            [.font : UIFont.systemFont(ofSize: 11),
             .foregroundColor: UIColor.label],
            for: .disabled
        )
        
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editButtonDidTap)
        )
        editButton.tintColor = .systemYellow
        
        return [flexibleSpace, countLabel, flexibleSpace, editButton]
    }
    
    @objc private func editButtonDidTap() {
        presenter?.viewDidRequestEditor(entityId: nil)
    }
}

extension ListViewImpl: ListView {
    func update(with presentables: [ListViewPresentable], animatingDifferences: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListViewPresentable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(presentables, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setToolbarTitle(_ text: String) {
        toolbarItems?[1].title = text                                   // TODO: Индекс убрать как-то
    }
}

extension ListViewImpl: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.viewDidSearch(text: searchController.searchBar.text)
    }
}

extension ListViewImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presentable = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        presenter?.viewDidRequestEditor(entityId: presentable.id)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let presentable = self?.dataSource?.itemIdentifier(for: indexPath) else {
                return
            }
            
            self?.presenter?.viewDidRemovePresentable(id: presentable.id)
            
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return self.makeContextMenu(for: indexPath)
        }
    }
    
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//            self.deleteItem(at: indexPath)
            print("delete")
        }
        
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
//            self.editItem(at: indexPath)
            print("edit")
        }
        
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
//            self.shareItem(at: indexPath)
            print("share")
        }
        
        return UIMenu(title: "", children: [edit, share, delete])
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
//        guard let indexPath = configuration.identifier as? IndexPath else { return }
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
    }
}
