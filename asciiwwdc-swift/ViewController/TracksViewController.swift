//
//  TracksViewController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/13.
//

import Foundation
import UIKit
import IGListKit
import SnapKit

class TracksViewController: UIViewController {
    
    var conference:Conference!
    
    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var adapter:ListAdapter = {
       return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        navigationItem.title = "Tracks"
        
        adapter.collectionView = collectionView
        adapter.delegate = self
        adapter.dataSource = self
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
}

extension TracksViewController: ListAdapterDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
}

extension TracksViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return conference.tracks!
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return TracksListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
