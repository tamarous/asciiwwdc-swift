//
//  ConferencesListSectionController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/2.
//

import UIKit
import IGListKit

class ConferencesListSectionController: ListSectionController {
    var conference:Conference!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top:0, left:0, bottom:15, right:0)
        
    }
    
}

extension ConferencesListSectionController {
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index:Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index:Int) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object:Any) {
        conference = object as? Conference
    }
}
