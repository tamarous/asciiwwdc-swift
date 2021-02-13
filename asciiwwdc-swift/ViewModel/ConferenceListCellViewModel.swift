//
//  ConferenceListCellViewModel.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/6.
//

import Foundation
import IGListKit

class ConferenceListCellViewModel: NSObject, ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return conference!
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        let anotherViewModel = object as! ConferenceListCellViewModel
        return self.conference?.identifier == anotherViewModel.conference?.identifier
    }
    
    var conference:Conference?
}
