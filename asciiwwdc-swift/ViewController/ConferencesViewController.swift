//
//  ConferencesViewController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/1.
//

import UIKit
import IGListKit

class ConferencesViewController: UIViewController {
    
    var viewModel:ConferencesViewModel = ConferencesViewModel()
    
    let collectionView: UICollectionView = {
        var frame:CGRect = .zero
        if let keyWindow = UIApplication.shared.windows.first {
            frame = CGRect(x:0, y:keyWindow.safeAreaInsets.top,width:keyWindow.bounds.width,height:keyWindow.bounds.height-keyWindow.safeAreaInsets.top-keyWindow.safeAreaInsets.bottom)
        }
        let view = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var adapter:ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize:0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startLoading() { conferences in
            print(conferences.count)
        }
        
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
}

extension ConferencesViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.conferences
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
