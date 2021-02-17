//
//  Session.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import IGListKit
import GRDB

class Session:NSObject {
    var identifier:String?
    var hrefLink:String?
    var name:String?
    var favorited:Bool = false
    var parentIdentifier:String?
    var index:Int?
    var storeId:Int64?
    
    init(dtNode:JiNode, ddNode:JiNode) {
        self.identifier = dtNode["id"]
        self.hrefLink = ddNode.xPath("./a").first?["href"]
        self.name = ddNode.xPath("./a").first?.content
        if let index = dtNode.content {
            self.index = Int(index)
        }
    }
    
    required init(row: Row) {
        self.identifier = row["identifier"]
        self.hrefLink = row["href"]
        self.name = row["name"]
        self.favorited = row["favorited"]
        self.parentIdentifier = row["parentIdentifier"]
        self.index = row["index"]
        self.storeId = row["storeId"]
    }
    
    static func queryFavorites() -> [Session] {
        var sessions:[Session] = []
        do {
            if let dbQueue = Session.createDataBase() {
                try dbQueue.read({ (db) -> [Session] in
                    sessions = try Session.fetchAll(db, sql: "SELECT * from session where favorited = 1")
                    return sessions
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
        return sessions
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

extension Session: BasePersistencyProtocol {
    func encode(to container: inout PersistenceContainer) {
        container["identifier"] = identifier
        container["href"] = hrefLink
        container["name"] = name
        container["favorited"] = favorited
        container["parentIdentifier"] = parentIdentifier
        container["index"] = index
        container["storeId"] = storeId
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        storeId = rowID
    }
    
    static func createDataBase() -> DatabaseQueue? {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            if let datapath = NSURL.init(string: path)?.appendingPathComponent("session.sqlite3") {
                let dbQueue = try DatabaseQueue(path: datapath.absoluteString)
                return dbQueue
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
        return nil
    }
    
    func insertRecord() {
        do {
            if let dbQueue = Session.createDataBase() {
                try dbQueue.write({ (db) in
                    try db.create(table: "session", ifNotExists: true, body: { (t) in
                        t.autoIncrementedPrimaryKey("storeId")
                        t.column("name", .text).notNull()
                        t.column("identifier", .text).notNull()
                        t.column("href", .text).notNull()
                        t.column("favorited", .boolean).notNull().defaults(to: false)
                        t.column("parentIdentifier", .text).notNull()
                        t.column("index", .integer).notNull()
                    })
                    try self.insert(db)
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
    }
    
    func updateRecord() {
        do {
            if let dbQueue = Session.createDataBase() {
                try dbQueue.write({ (db) in
                    try self.save(db)
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
    }
}

