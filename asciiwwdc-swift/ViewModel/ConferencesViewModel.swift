//
//  ConferencesViewModel.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import IGListKit
import UIKit

class ConferencesViewModel:NSObject {
    var cellViewModels:[ConferenceListCellViewModel] = []
    var loading:Bool = false
    
    func loadRequest(completion:(() -> Void)?) -> Void {
        loading = true
        DataManager.sharedInstance.getAllConference { [weak self] (conferences) in
            self?.cellViewModels = conferences.map { (conference) in
                let viewModel = ConferenceListCellViewModel()
                viewModel.conference = conference
                return viewModel
            }
            self?.loading = false
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}

extension ConferencesViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
