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
    var parentIdentifier:String?
    var index:Int?
    
    var connection:Connection?
    
    init(dtNode:JiNode, ddNode:JiNode) {
        self.identifier = dtNode["id"]
        self.hrefLink = ddNode.xPath("./a").first?["href"]
        self.name = ddNode.xPath("./a").first?.content
        if let index = dtNode.content {
            self.index = Int(index)
        }
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
    func createDataBase() -> Connection? {
        if let connection = self.connection {
            return connection
        }
        
        let documentPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPathURL = URL.init(string: documentPath)?.appendingPathComponent("session.sqlite")
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
        let sessions = Table("sessions")
        if let db = self.createDataBase() {
            do {
                try db.run(sessions.create(ifNotExists: true) { t in
                    let name = Expression<String?>("name")
                    let identifier = Expression<String>("identifier")
                    let href = Expression<String?>("hrefLink")
                    let parentId = Expression<String?>("parentIdentifier")
                    let favorited = Expression<Bool>("favorited")
                    
                    t.column(identifier, primaryKey: true)
                    t.column(name)
                    t.column(href)
                    t.column(parentId)
                    t.column(favorited)
                })
                return sessions
            } catch {
                print("\(#fileID) \(#line) error: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func insertRecord() {
        DispatchQueue.global().async {
            let sessions = self.createTable()
            let name = Expression<String?>("name")
            let identifier = Expression<String>("identifier")
            let href = Expression<String?>("hrefLink")
            let parentId = Expression<String?>("parentIdentifier")
            let favorited = Expression<Bool>("favorited")
            do {
                if let db = self.createDataBase(), let sessions = sessions {
                    try db.run(sessions.insert(or: .replace,
                                                  name <- self.name,
                                                  identifier <- self.identifier!,
                                                  href <- self.hrefLink,
                                                  parentId <- self.parentIdentifier,
                                                  favorited <- self.favorited
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
                if let sessions = self.createTable(), let db = self.createDataBase() {
                    let name = Expression<String?>("name")
                    let identifier = Expression<String>("identifier")
                    let href = Expression<String?>("hrefLink")
                    let parentId = Expression<String?>("parentIdentifier")
                    let favorited = Expression<Bool>("favorited")
                    
                    let thisRecord = sessions.filter(identifier == self.identifier!)
                    try db.run(thisRecord.update(name <- self.name, href <- self.hrefLink, parentId <- self.parentIdentifier, favorited <- self.favorited))
                }
            } catch {
                print("\(#fileID) \(#line) error: \(error)")
            }
        }
    }
}

