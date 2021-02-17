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
    
    var viewModel:ConferencesViewModel?
    
    init(viewModel:ConferencesViewModel) {
        self.viewModel = viewModel
    }
    
    override func numberOfItems() -> Int {
        return self.viewModel?.cellViewModels.count ?? 0
    }
    
    override func sizeForItem(at index:Int) -> CGSize {
        if let width = collectionContext?.containerSize.width {
            return CGSize.init(width: width / 2, height: 144)
        }
        return .zero
    }
    
    override func cellForItem(at index:Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: ConferenceListCell.self, for: self, at: index)
        if let cell = cell as? ConferenceListCell, let cellViewModel = self.viewModel?.cellViewModels[index] {
            cell.updateWithData(cellViewModel: cellViewModel)
        }
        return cell
    }
    
    
    override func didSelectItem(at index: Int) {
        if let conference = self.viewModel?.cellViewModels[index].conference {
            let tracksVC = TracksViewController()
            tracksVC.conference = conference
            viewController?.navigationController?.pushViewController(tracksVC, animated: true)
        }
    }
    
    override func didUpdate(to object:Any) {
        if let cellViewModel =  object as? ConferenceListCellViewModel {
            self.cellViewModel = cellViewModel
        }
    }
}
