//
//  Track.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit
import GRDB

class Track: NSObject, BaseHtmlModelProtocol {
    var name:String?
    var identifier:String?
    var sessions:[Session]?
    var parentIdentifier:String?
    var storeId:Int64?
    
    required init(rootNode: JiNode, parentIdentifier: String?) {
        self.parentIdentifier = parentIdentifier
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
            if let parentIdentifier = self.parentIdentifier {
                session.parentIdentifier = "\(parentIdentifier)-\(self.identifier!)"
            }
            session.insertRecord()
            sessions.append(session)
        }
        self.sessions = sessions
    }

    required init(row: Row) {
        self.identifier = row["identifier"]
        self.name = row["name"]
        self.parentIdentifier = row["parentIdentifier"]
        self.storeId = row["storeId"]
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
    static func createDataBase() -> DatabaseQueue? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        if let datapath = NSURL.init(string: path)?.appendingPathComponent("track.sqlite3") {
            do {
                let dbQueue = try DatabaseQueue(path: datapath.absoluteString)
                return dbQueue
            } catch {
                print("\(#fileID)-\(#line) error:\(error)")
            }
        }
        
        return nil
    }
    
    func insertRecord() {
        if let dbQueue = Track.createDataBase() {
            do {
                try dbQueue.write({ db in
                    try db.create(table: "track", ifNotExists: true, body: { (t) in
                        t.autoIncrementedPrimaryKey("storeId")
                        t.column("identifier", .text).notNull()
                        t.column("name", .text).notNull()
                        t.column("parentIdentifier", .text).notNull()
                    })
                    try self.insert(db)
                })
            } catch {
                print("\(#fileID)-\(#line) error:\(error)")
            }
        }
    }
    
    func updateRecord() {
        do {
            if let dbQueue = Track.createDataBase() {
                try dbQueue.write({ (db) in
                    try self.update(db)
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        storeId = rowID
    }
    
    func encode(to container: inout PersistenceContainer) {
        container["storeId"] = storeId
        container["name"] = name
        container["parentIdentifier"] = parentIdentifier
        container["identifier"] = identifier
    }
}
