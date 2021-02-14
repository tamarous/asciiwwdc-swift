//
//  Session.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit
import SQLite

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
        self.imageUrl = "https://www.asciiwwdc.com" + (rootNode.xPath("./header/img").first?["src"])!
        self.desc = rootNode.xPath("./header/hgroup/h2").first?.content
        self.time = rootNode.xPath("./header/time").first?["content"]?.replacingOccurrences(of: "T", with: ":")
        
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
            conference.insertRecord()
            resultArray.append(conference)
        }
        return resultArray
    }
}

extension Conference: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.identifier! as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else {
            return true
        }
        guard let object = object as? Conference else {
            return false
        }
        return self.identifier == object.identifier
    }
}

extension Conference: BasePersistencyProtocol {
    static func createDataBase() -> Connection? {
        let documentPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPathURL = URL.init(string: documentPath)?.appendingPathComponent("conference.sqlite")
        if let dbUrlStr = dbPathURL?.absoluteString {
            do {
                let db = try Connection(dbUrlStr)
                return db
            } catch {
                print("error: \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func createTable() -> Table? {
        let conferences = Table("conferences")
        if let db = Conference.createDataBase() {
            do {
                try db.run(conferences.create(ifNotExists: true) { t in
                    let name = Expression<String?>("name")
                    let imageUrl = Expression<String?>("imageUrl")
                    let desc = Expression<String?>("desc")
                    let identifier = Expression<String>("identifier")
                    let time = Expression<String?>("time")
                    
                    t.column(identifier, primaryKey: true)
                    t.column(name)
                    t.column(imageUrl)
                    t.column(desc)
                    t.column(time)
                })
                return conferences
            } catch {
                print("error: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func insertRecord() {
        let conferences = Conference.createTable()
        let name = Expression<String?>("name")
        let imageUrl = Expression<String?>("imageUrl")
        let desc = Expression<String?>("desc")
        let identifier = Expression<String>("identifier")
        let time = Expression<String?>("time")
        do {
            if let db = Conference.createDataBase(), let conferences = conferences {
                try db.run(conferences.insert(or: .replace,
                                              name <- self.name,
                                              imageUrl <- self.imageUrl,
                                              desc <- self.desc,
                                              identifier <- self.identifier!,
                                              time <- self.time
                ))
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    func deleteRecord() {
    }
}
