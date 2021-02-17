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

struct Location: BaseHtmlModelProtocol {
    var name:String?
    var streetAddress:String?
    var addressLocality:String?
    var addressRegion:String?
    var postalCode:String?
    var addressCounty:String?
    
    init(rootNode: JiNode) {
        self.name = rootNode.children.filter({ (node) -> Bool in
            node["itemprop"] == "name"
        }).first?.content
        self.streetAddress = rootNode.children.filter({ (node) -> Bool in
            node["itemprop"] == "streetAddress"
        }).first?.content
        self.addressLocality = rootNode.children.filter({ (node) -> Bool in
            node["itemprop"] == "addressLocality"
        }).first?.content
        self.addressRegion = rootNode.children.filter({ (node) -> Bool in
            node["itemprop"] == "addressRegion"
        }).first?.content
        self.postalCode = rootNode.children.filter({ (node) -> Bool in
            node["itemprop"] == "postalCode"
        }).first?.content
        self.addressCounty = rootNode.children.filter({ (node) -> Bool in
            node["itemprop"] == "addressCountry"
        }).first?.content
    }
}

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
    var storeId:Int64?

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
            track.parentIdentifier = self.identifier
            track.insertRecord()
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
    func encode(to container: inout PersistenceContainer) {
        container["storeId"] = storeId
        container["name"] = name
        container["imageUrl"] = imageUrl
        container["desc"] = desc
        container["time"] = time
        container["identifier"] = identifier
        container["location_name"] = location?.name
        container["location_street"] = location?.streetAddress
        container["location_region"] = location?.addressRegion
        container["location_locality"] = location?.addressLocality
        container["location_postal"] = location?.postalCode
        container["location_county"] = location?.addressCounty
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        storeId = rowID
    }
    
    func createDataBase() -> DatabaseQueue? {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            if let datapath = NSURL.init(string: path)?.appendingPathComponent("conference.sqlite3") {
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
            if let dbQueue = self.createDataBase() {
                try dbQueue.write({ (db) in
                    try db.create(table: "conference", ifNotExists: true, body: { (t) in
                        t.autoIncrementedPrimaryKey("storeId")
                        t.column("name", .text).notNull()
                        t.column("imageUrl", .text).notNull()
                        t.column("desc", .text).notNull()
                        t.column("time", .text).notNull()
                        t.column("identifier", .text).notNull()
                        t.column("location_name", .text).notNull()
                        t.column("location_street", .text).notNull()
                        t.column("location_region", .text).notNull()
                        t.column("location_locality", .text).notNull()
                        t.column("location_postal", .text).notNull()
                        t.column("location_county", .text).notNull()
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
            if let dbQueue = self.createDataBase() {
                try dbQueue.write({ (db) in
                    try self.update(db)
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
    }
}
