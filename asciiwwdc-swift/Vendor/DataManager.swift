//
//  DataManager.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/23.
//

import Foundation

class DataManager {
    static let sharedInstance = DataManager()
    
    func getAllConference(completion: ((_ conferences:[Conference]) -> Void)?) {
        DataBaseManager.sharedInstance.getAllConference { (conferences:[Conference]) in
            if (conferences.count > 0) {
                if let completion = completion {
                    completion(conferences)
                }
            } else {
                NetworkManager.sharedInstance.getAllConference(completion: completion)
            }
        }
    }
}
