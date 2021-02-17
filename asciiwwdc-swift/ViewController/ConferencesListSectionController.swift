//
//  ConferencesListSectionController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/2.
//

import UIKit
import IGListKit

class ConferencesListSectionController: ListSectionController {
    var cellViewModel:ConferenceListCellViewModel?
    
    override init() {
        super.init()
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index:Int) -> CGSize {
        if let width = collectionContext?.containerSize.width {
            return CGSize.init(width: width, height: 120)
        }
        return .zero
    }
    
    override func cellForItem(at index:Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: ConferenceListCell.self, for: self, at: index)
        if let cell = cell as? ConferenceListCell, let cellViewModel = cellViewModel {
            cell.updateWithData(cellViewModel: cellViewModel)
        }
        return cell
    }
    
    
    override func didSelectItem(at index: Int) {
        if let conference = cellViewModel?.conference {
            let tracksVC = TracksViewController()
            tracksVC.conference = conference
            viewController?.navigationController?.pushViewController(tracksVC, animated: true)
        }
    }
    
    override func didUpdate(to object:Any) {
        cellViewModel = object as? ConferenceListCellViewModel
    }
}
