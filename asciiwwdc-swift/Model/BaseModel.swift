//
//  BaseModel.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import GRDB

protocol HtmlModelArrayProtocol {
    static func createModelArray(jiNodes:[JiNode]) -> [Any]
}

protocol HtmlModelProtocol {
    static func createModel(jiNode:JiNode) -> Any
}

protocol BaseHtmlModelProtocol {
   
}

protocol BasePersistencyProtocol:PersistableRecord, FetchableRecord {
    static func createDataBase() -> DatabaseQueue?
    
    func insertRecord()

    func updateRecord()
}
