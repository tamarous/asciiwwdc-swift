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

class Session:NSObject {
    var identifier:String?
    var hrefLink:String?
    var name:String?
    var favorited:Bool = false
    
    init(dtNode:JiNode, ddNode:JiNode) {
        self.identifier = dtNode["id"]
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

extension Session: BasePersistencyProtocol {
    static func createDataBase() -> Connection? {
        let documentPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPathURL = URL.init(string: documentPath)?.appendingPathComponent("session.sqlite")
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
        let sessions = Table("sessions")
        if let db = Session.createDataBase() {
            do {
                try db.run(sessions.create(ifNotExists: true) { t in
                    let name = Expression<String?>("name")
                    let identifier = Expression<String>("identifier")
                    let href = Expression<String?>("hrefLink")
                    
                    t.column(identifier, primaryKey: true)
                    t.column(name)
                    t.column(href)
                })
                return sessions
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func insertRecord() {
        let sessions = Session.createTable()
        let name = Expression<String?>("name")
        let identifier = Expression<String>("identifier")
        let href = Expression<String?>("hrefLink")
        do {
            if let db = Session.createDataBase(), let sessions = sessions {
                try db.run(sessions.insert(or: .replace,
                                              name <- self.name,
                                              identifier <- self.identifier!,
                                              href <- self.hrefLink
                ))
            }
        } catch {
            
        }
    }
    
    func deleteRecord() {
    }
}

