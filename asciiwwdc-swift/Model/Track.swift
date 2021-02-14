//
//  Track.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit
import SQLite

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
            let session = Session(dtNode: dtNode, ddNode: ddNode)
            sessions.append(session)
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

extension Track: BasePersistencyProtocol {
    static func createDataBase() -> Connection? {
        let documentPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPathURL = URL.init(string: documentPath)?.appendingPathComponent("track.sqlite")
        if let dbUrlStr = dbPathURL?.absoluteString {
            do {
                let db = try Connection(dbUrlStr)
                return db
            } catch {
                return nil
            }
        }
        return nil
    }
    
    static func createTable() -> Table? {
        let tracks = Table("tracks")
        if let db = Conference.createDataBase() {
            do {
                try db.run(tracks.create(ifNotExists: true) { t in
                    let name = Expression<String?>("name")
                    let identifier = Expression<String>("identifier")
                    
                    t.column(identifier, primaryKey: true)
                    t.column(name)
                })
                return tracks
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func insertRecord() {
        let tracks = Track.createTable()
        let name = Expression<String?>("name")
        let identifier = Expression<String>("identifier")
        do {
            if let db = Track.createDataBase(), let tracks = tracks {
                try db.run(tracks.insert(or: .replace,
                                              name <- self.name,
                                              identifier <- self.identifier!
                ))
            }
        } catch {
            
        }
    }
    
    func deleteRecord() {
    }
}
