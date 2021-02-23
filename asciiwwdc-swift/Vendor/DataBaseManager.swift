//
//  DataBaseManager.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/23.
//

import Foundation
import GRDB

class DataBaseManager {
    static let sharedInstance = DataBaseManager()
    
    func getAllConference(completion: (([Conference]) -> Void)?) {
        do {
            if let dbQueue = Conference.createDataBase() {
                try dbQueue.read({ db in
                    let conferences = try Conference.fetchAll(db)
                    for conference in conferences {
                        if let identifier = conference.identifier {
                            conference.tracks = getAllTracks(parentIdentifier: identifier)
                        }
                    }
                    if let completion = completion {
                        completion(conferences)
                    }
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
    }
    
    func getAllTracks(parentIdentifier:String) -> [Track]? {
        do {
            if let dbQueue = Track.createDataBase() {
                try dbQueue.read({ (db) -> [Track] in
                    let tracks = try Track.filter(Column("parentIdentifier") == parentIdentifier).fetchAll(db)
                    for track in tracks {
                        if let identifier = track.identifier {
                            track.sessions = getAllSessions(parentIdentifier: identifier)
                        }
                    }
                    return tracks
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
        return []
    }
    
    func getAllSessions(parentIdentifier:String) -> [Session]? {
        do {
            if let dbQueue = Session.createDataBase() {
                try dbQueue.read({ (db) -> [Session] in
                    let sessions = try Session.filter(Column("parentIdentifier") == parentIdentifier).fetchAll(db)
                    return sessions
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
        return []
    }
}
