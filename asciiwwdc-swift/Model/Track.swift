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
    var parentIdentifier:String?
    
    var connection:Connection?
    
    required init(rootNode: JiNode) {
        self.identifier = rootNode["id"]
        self.name = rootNode.xPath("./h1").first?.content
        
        let dtNodes = rootNode.xPath("./dl/dt")
        let ddNodes = rootNode.xPath("./dl/dd")
        
        guard dtNodes.count == ddNodes.count else {
            return
        }
        let count = dtNodes.count
        var sessions:[Session] = []
        for i in 0..<count {
            let dtNode = dtNodes[i]
            let ddNode = ddNodes[i]
            let session = Session(dtNode: dtNode, ddNode: ddNode)
            session.parentIdentifier = self.identifier
            session.insertRecord()
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
    func createDataBase() -> Connection? {
        if let connection = self.connection {
            return connection
        }
        
        let documentPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPathURL = URL.init(string: documentPath)?.appendingPathComponent("track.sqlite")
        if let dbUrlStr = dbPathURL?.absoluteString {
            do {
                self.connection = try Connection(dbUrlStr)
                return self.connection
            } catch {
                print("\(#fileID) \(#line) error: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func createTable() -> Table? {
        let tracks = Table("tracks")
        if let db = self.createDataBase() {
            do {
                try db.run(tracks.create(ifNotExists: true) { t in
                    let name = Expression<String?>("name")
                    let identifier = Expression<String>("identifier")
                    let parentId = Expression<String?>("parentIdentifier")
                    
                    t.column(identifier, primaryKey: true)
                    t.column(name)
                    t.column(parentId)
                })
                return tracks
            } catch {
                print("\(#fileID) \(#line) error: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func insertRecord() {
        DispatchQueue.global().async {
            let tracks = self.createTable()
            let name = Expression<String?>("name")
            let identifier = Expression<String>("identifier")
            let parentId = Expression<String?>("parentIdentifier")
            do {
                if let db = self.createDataBase(), let tracks = tracks {
                    try db.run(tracks.insert(or: .replace,
                                                  name <- self.name,
                                                  identifier <- self.identifier!,
                                                  parentId <- self.parentIdentifier
                    ))
                }
            } catch {
                print("\(#fileID) \(#line) error: \(error)")
            }
        }
    }
    
    func deleteRecord() {
        
    }
    
    func updateRecord() {
        DispatchQueue.global().async {
            do {
                if let tracks = self.createTable(), let db = self.createDataBase() {
                    let name = Expression<String?>("name")
                    let identifier = Expression<String>("identifier")
                    let parentId = Expression<String?>("parentIdentifier")
                    let thisRecord = tracks.filter(identifier == self.identifier!)
                    try db.run(thisRecord.update(name <- self.name, parentId <- self.parentIdentifier))
                }
            } catch {
                print("\(#fileID) \(#line) error: \(error)")
            }
        }
    }
}
