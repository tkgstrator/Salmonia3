//
//  RealmPlayerResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmPlayerResult: Object, Decodable {
    @objc dynamic var name: String?
    @objc dynamic var pid: String?
    @objc dynamic var deadCount: Int = 0
    @objc dynamic var helpCount: Int = 0
    @objc dynamic var goldenIkuraNum: Int = 0
    @objc dynamic var ikuraNum: Int = 0
    @objc dynamic var specialId: Int = 0
    dynamic var bossKillCount = List<Int>()
    dynamic var weaponList = List<Int>()
    dynamic var specialCount = List<Int>()
    let result = LinkingObjects(fromType: RealmCoopResult.self, property: "player")

    override static func indexedProperties() -> [String] {
        return ["nsaid"]
    }
    
    private enum Codingkeys: String, CodingKey {
        case name           = "name"
        case pid            = "pid"
        case deadCount      = "dead_count"
        case helpCount      = "help_count"
        case goldenIkuraNum = "golden_ikura_num"
        case ikuraNum       = "ikura_num"
        case weaponList     = "weapon_list"
        case specialCount   = "special_count"
    }
    
    public required convenience init(from decoder: Decoder) {
        self.init()
    }
}
