//
//  TracksListSectionController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/13.
//

import Foundation
import UIKit
import IGListKit

class TracksListSectionController: ListSectionController {
    
    var track:Track?
    
    override init() {
        super.init()
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let cell = collectionContext!.dequeueReusableCell(of: TrackListCell.self, for: self, at: index) as? TrackListCell, let track = self.track {
            cell.updateWithData(track: track)
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func didSelectItem(at index: Int) {
        if let track = self.track {
            let sessionsVC = SessionsViewController()
            sessionsVC.sessions = track.sessions
            viewController?.navigationController?.pushViewController(sessionsVC, animated: true)
        }
    }
    
    override func didUpdate(to object: Any) {
        track = object as? Track
    }
    
}
