//
//  DataManager.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/23.
//

import Foundation

class DataManager {
    static let sharedInstance = DataManager()
    
    func getAllConference(completion: (([Conference]) -> Void)?) {
        DataBaseManager.sharedInstance.getAllConference(completion: completion)
    }
}
