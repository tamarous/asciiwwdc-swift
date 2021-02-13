//
//  Track.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit

class Track: NSObject, BaseHtmlModelProtocol {
    var name:String?
    var identifier:String?
    var sessions:[Session]?
    
    required init(rootNode: JiNode) {
        self.identifier = rootNode["id"]
        self.name = rootNode.xPath("./h1").first?.content
        
        let dtNodes = rootNode.xPath("./dl/dt")
        let ddNodes = rootNode.xPath("./dl/dd")
        
        guard dtNodes.count == ddNodes.count else {
            print("mismatched nodes count")
            return
        }
        let count = dtNodes.count
        var sessions:[Session] = []
        for i in 0..<count {
            let dtNode = dtNodes[i]
            let ddNode = ddNodes[i]
            sessions.append(Session(dtNode: dtNode, ddNode: ddNode))
        }
        self.sessions = sessions
    }
}

extension Track: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else {
            return true
        }
        guard let track = object as? Track else {
            return false
        }
        return self.identifier == track.identifier
    }
}
