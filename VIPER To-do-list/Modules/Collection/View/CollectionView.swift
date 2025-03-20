//
//  CollectionController.swift
//  VIPER To-do-list
//
//  Created by @_@ on 20.03.2025.
//

import UIKit

protocol CollectionView: AnyObject {
    
}

class CollectionViewImpl: UICollectionViewController {
    
    var presenter: CollectionPresenter?
    
    init() {
        let layout = UICollectionViewLayout()               // TODO: Create layout
        
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = .red
        presenter?.viewDidLoaded()
    }


}

extension CollectionViewImpl: CollectionView {
    
}
