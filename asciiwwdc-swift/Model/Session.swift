//
//  Session.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji

struct Session {
    var identifier:String?
    var index:Int?
    var hrefLink:String?
    var name:String?
    
    init(dtNode:JiNode, ddNode:JiNode) {
        self.identifier = dtNode["id"]
        if let index = dtNode.content {
            self.index = Int(index)
        }
        self.hrefLink = ddNode.xPath("./a").first?["href"]
        self.name = ddNode.xPath("./a").first?.content
    }
}
