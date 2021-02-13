//
//  ConferencesViewController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/1.
//

import UIKit
import IGListKit
import SnapKit

class ConferencesViewController: UIViewController {
    
    var viewModel:ConferencesViewModel = ConferencesViewModel()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .white
        return view
    }()
    
    lazy var adapter:ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize:0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Conferences"
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
        
        viewModel.loadRequest {
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
}

extension ConferencesViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.cellViewModels
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ConferencesListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
