//
//  ViewController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    var viewModel:ConferencesViewModel = ConferencesViewModel()
    
    var collectionView:UICollectionView!

    var dataSource:UICollectionViewDiffableDataSource<Section, Conference>!
    
    var snapshot:NSDiffableDataSourceSnapshot<Section, Conference>!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var conf:UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        conf.backgroundColor = .systemBackground
        
        let layout:UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout.list(using: conf)
        
        self.navigationItem.title = "ASCIIWWDC-Swift"
    
        var collectionViewFrame = view.bounds
        if let keyWindow = UIApplication.shared.windows.first?.safeAreaInsets {
            collectionViewFrame = CGRect(x: 0, y: keyWindow.top, width: view.bounds.width, height: view.bounds.height-keyWindow.top-keyWindow.bottom)
        }
        collectionView = UICollectionView.init(frame: collectionViewFrame, collectionViewLayout: layout)

        view.addSubview(collectionView)

        let cellRegist = UICollectionView.CellRegistration<UICollectionViewListCell, Conference> { (cell, indexPath, item ) in
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Conference>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Conference) -> UICollectionViewCell? in
            
            // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegist,
                                                                    for: indexPath,
                                                                    item: identifier)
            // Configure cell appearance
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        
        snapshot = NSDiffableDataSourceSnapshot<Section, Conference>()
        snapshot.appendSections([.main])
        
        viewModel.startLoading() { [weak self] (conferences) in
            self?.snapshot.appendItems(conferences, toSection: .main)
            self?.dataSource.apply((self?.snapshot)!, animatingDifferences: false)
        }
    }
}

