//
//  FavoriteSessionsViewController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/17.
//

import Foundation
import UIKit
import IGListKit

class FavoriteSessionsViewController: UIViewController {
    var sessions:[Session]?
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        return collectionView
    }()
    
    lazy var adapter:ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.backgroundColor = .clear
        navigationItem.title = "Favorites"
        
        adapter.collectionView = collectionView
        adapter.delegate = self
        adapter.dataSource = self
        
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessions = Session.queryFavorites()
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = collectionView.collectionViewLayout
        layout.invalidateLayout()
    }
}

extension FavoriteSessionsViewController: ListAdapterDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
}

extension FavoriteSessionsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sessions ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SessionsListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
