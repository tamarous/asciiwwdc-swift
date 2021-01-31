//
//  Location.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/1/31.
//

import Foundation
import Ji

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
