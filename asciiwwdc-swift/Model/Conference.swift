//
//  Session.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit

class Conference:NSObject,HtmlModelArrayProtocol,BaseHtmlModelProtocol {
    static func == (lhs: Conference, rhs: Conference) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var name:String?
    var imageUrl:String?
    var desc:String?
    var location:Location?
    var identifier:String?
    var time:String?
    var tracks:[Track]?
    
    required init(rootNode: JiNode) {
        self.identifier = rootNode["id"]
        self.name = rootNode.xPath("./header/hgroup/h1").first?.content
        self.imageUrl = rootNode.xPath("./header/img").first?["src"]
        self.desc = rootNode.xPath("./header/hgroup/h2").first?.content
        self.time = rootNode.xPath("./header/time").first?["content"]
        
        if let locationNode:JiNode = rootNode.xPath("./header/address").first {
            self.location = Location(rootNode: locationNode)
        }
        
        let trackNodes = rootNode.xPath("./div/section[@class='track']")
        var tracksArray:[Track] = []
        for trackNode in trackNodes {
            let track = Track(rootNode:trackNode)
            tracksArray.append(track)
        }
        self.tracks = tracksArray
    }
    
    static func createModelArray(jiNodes: [JiNode]) -> [Any] {
        var resultArray:[Conference] = []
        for aNode in jiNodes {
            let conference = Conference(rootNode: aNode)
            resultArray.append(conference)
        }
        return resultArray
    }
}

extension Conference: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
}
