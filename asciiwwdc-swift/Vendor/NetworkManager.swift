//
//  NetworkManager.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Alamofire
import Ji

struct NetworkManager {
    public let baseUrl = "https://www.asciiwwdc.com"
    
    static let sharedInstance = NetworkManager()
    
    func getAllConference(completion: (([Conference]) -> Void)?) {
        AF.request(baseUrl).responseData { response in
            guard let validData = response.data else {
                print("response data nil")
                return
            }
            guard let htmlData = Ji(htmlData: validData) else {
                return
            }
            if let jiNodes = htmlData.xPath("//body/div/div/section[@class='conference']") {
                let conferences = Conference.createModelArray(jiNodes: jiNodes) as? [Conference]
                if let completion = completion, let conferences = conferences {
                    completion(conferences)
                }
            }
        }
    }
}
