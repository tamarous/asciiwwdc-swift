//
//  BaseModel.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji
import SQLite

protocol HtmlModelArrayProtocol {
    static func createModelArray(jiNodes:[JiNode]) -> [Any]
}

protocol HtmlModelProtocol {
    static func createModel(jiNode:JiNode) -> Any
}

protocol BaseHtmlModelProtocol {
    init(rootNode:JiNode)
}

protocol BasePersistencyProtocol {
    @discardableResult func createDataBase() -> Connection?
    
    @discardableResult func createTable() -> Table?
    
    func insertRecord()
    
    func deleteRecord()
    
    func updateRecord()
}
