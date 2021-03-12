//
//  RealmPlayerResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmPlayerResult: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var nsaid: String?
    @objc dynamic var dead_count: Int = 0
    @objc dynamic var help_count: Int = 0
    @objc dynamic var golden_ikura_num: Int = 0
    @objc dynamic var ikura_num: Int = 0
    @objc dynamic var  special_id: Int = 0
    dynamic var boss_kill_counts = List<Int>()
    dynamic var weapon_list = List<Int>()
    dynamic var special_counts = List<Int>()
    let result = LinkingObjects(fromType: RealmCoopResult.self, property: "player")

    override static func indexedProperties() -> [String] {
        return ["nsaid"]
    }
}
