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
                    if conferences.count == 0 {
                        if let completion = completion {
                            completion(conferences)
                        }
                        return
                    }
                    for conference in conferences {
                        if let identifier = conference.identifier {
                            if let tracks = getAllTracks(parentIdentifier: identifier) {
                                conference.tracks = tracks
                            }
                        }
                    }
                    if let completion = completion {
                        completion(conferences)
                    }
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
            if let completion = completion {
                completion([])
                return
            }
        }
    }
    
    func getAllTracks(parentIdentifier:String) -> [Track]? {
        var tracks:[Track] = []
        do {
            if let dbQueue = Track.createDataBase() {
                try dbQueue.read({ (db) -> [Track] in
                    tracks = try Track.filter(Column("parentIdentifier") == parentIdentifier).fetchAll(db)
                    for track in tracks {
                        if let identifier = track.identifier {
                            let sessionIdentifier = "\(track.parentIdentifier!)-\(identifier)"
                            if let sessions = getAllSessions(parentIdentifier: sessionIdentifier) {
                                track.sessions = sessions
                            }
                        }
                    }
                    return tracks
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
        return tracks
    }
    
    func getAllSessions(parentIdentifier:String) -> [Session]? {
        var sessions:[Session] = []
        do {
            if let dbQueue = Session.createDataBase() {
                try dbQueue.read({ (db) -> [Session] in
                    sessions = try Session.filter(Column("parentIdentifier") == parentIdentifier).fetchAll(db)
                    return sessions
                })
            }
        } catch {
            print("\(#fileID)-\(#line), error:\(error)")
        }
        return sessions
    }
}
