//
//  CollectionController.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

protocol CollectionView: AnyObject {
    func update(with presentables: [CollectionViewPresentable])
}

class CollectionViewImpl: UIViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, CollectionViewPresentable>?
    
    var presenter: CollectionPresenter?
    private let tableView: UITableView = UITableView()
    private lazy var dataSource: DataSource = createDataSource()
    
    override func loadView() {
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter?.viewDidLoad()
    }

 
    private func createDataSource() -> DataSource {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")
            cell?.contentConfiguration = nil
            return cell
        }
    }
}



extension CollectionViewImpl: CollectionView {
    func update(with presentables: [CollectionViewPresentable]) {
        // snapshot update
    }
}

import SwiftUI

struct CollectionViewImpl_Previews: PreviewProvider {
    static var previews: some View {
        CollectionViewImpl().showPreview()
    }
}
