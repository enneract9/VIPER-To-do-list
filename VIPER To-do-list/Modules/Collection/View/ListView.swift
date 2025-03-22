//
//  CollectionController.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

protocol ListView: AnyObject {
    func update(with presentables: [ListViewPresentable])
    func setToolbarTitle(_ text: String)
}

class ListViewImpl: UIViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ListViewPresentable>?
    
    var presenter: ListPresenter?
    private let tableView: UITableView = UITableView()
    private lazy var dataSource: DataSource = createDataSource()
    private lazy var searchController: UISearchController = createSearchController()
    
    override func loadView() {
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        title = "Задачи"
        
        configureTableView()
        configureNavigation()
    }
    
    private func configureTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: ListViewCellConfiguration.reuseId
        )
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .label.withAlphaComponent(0.5)
        tableView.separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    private func configureNavigation() {
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        toolbarItems = createToolbarItems()
        
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .secondarySystemBackground
        
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
    }
 
    private func createDataSource() -> DataSource {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, presentable in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCellConfiguration.reuseId)
            cell?.contentConfiguration = ListViewCellConfiguration(
                presentable: presentable,
                checkboxDidToggle: { [weak self] value in
                    self?.presenter?.checkboxValueDidChange(with: presentable.id, newValue: value)
                }
            )
            return cell
        }
    }
    
    private func createSearchController() -> UISearchController {
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
        presenter?.viewDidRequestEditor(with: nil)
    }
}

extension ListViewImpl: ListView {
    func update(with presentables: [ListViewPresentable]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListViewPresentable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(presentables, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
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
        presenter?.viewDidRequestEditor(with: presentable)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
