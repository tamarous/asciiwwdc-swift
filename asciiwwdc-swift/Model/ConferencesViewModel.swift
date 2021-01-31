//
//  ConferencesViewModel.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation

class ConferencesViewModel:NSObject {
    var conferences:[Conference] = []
    
    var loading:Bool = false
    
    func startLoading(completion:(([Conference]) -> Void)?) -> Void {
        loading = true
        NetworkManager.sharedInstance.getAllConference { [weak self] (conferences) in
            self?.conferences = conferences
            self?.loading = false
            if let completion = completion {
                completion(conferences)
            }
        }
    }
}
