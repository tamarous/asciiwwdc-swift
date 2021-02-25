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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        return view
    }()
    
    lazy var adapter:ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize:0)
    }()
    
    var loadingView:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Conferences"
        
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
        
        view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(44)
        }
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        viewModel.loadRequest { [weak self] in
            self?.loadingView.stopAnimating()
            self?.loadingView.isHidden = true
            self?.loadingView.removeFromSuperview()
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = collectionView.collectionViewLayout
        layout.invalidateLayout()
    }
}

extension ConferencesViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [viewModel]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ConferencesListSectionController.init(viewModel:self.viewModel)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
