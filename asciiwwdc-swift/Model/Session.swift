//
//  Session.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit

class Session:NSObject {
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

extension Session: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.identifier! as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else {
            return true
        }
        guard let session = object as? Session else {
            return false
        }
        return self.identifier == session.identifier
    }
}
