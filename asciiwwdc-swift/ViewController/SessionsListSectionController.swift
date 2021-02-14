//
//  SessionsListSectionController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/13.
//

import Foundation
import IGListKit
import UIKit

class SessionsListSectionController: ListSectionController {
    var session: Session?
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 44.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let cell = collectionContext!.dequeueReusableCell(of: SessionListCell.self, for: self, at: index) as? SessionListCell, let session = self.session {
            cell.updateWithData(session: session)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        session = object as? Session
    }
    
    override func didSelectItem(at index: Int) {
        if let session = self.session {
            let webViewVC = WebViewController()
            webViewVC.session = session
            viewController?.navigationController?.pushViewController(webViewVC, animated: true)
        }
    }
}
