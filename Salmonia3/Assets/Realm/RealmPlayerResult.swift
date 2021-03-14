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
    
    private enum CodingKeys: String, CodingKey {
        case name           = "name"
        case pid            = "pid"
        case deadCount      = "dead_count"
        case helpCount      = "help_count"
        case goldenIkuraNum = "golden_ikura_num"
        case ikuraNum       = "ikura_num"
        case specialId      = "special"
        case weaponList     = "weapon_list"
        case specialCount   = "special_counts"
        case bossKillCounts = "boss_kill_counts"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try? container.decode(String.self, forKey: .name)
        pid = try? container.decode(String.self, forKey: .pid)
        deadCount = try container.decode(Int.self, forKey: .deadCount)
        helpCount = try container.decode(Int.self, forKey: .helpCount)
        goldenIkuraNum = try container.decode(Int.self, forKey: .goldenIkuraNum)
        ikuraNum = try container.decode(Int.self, forKey: .ikuraNum)
//        let _weaponList = try container.decodeIfPresent(Int.self, forKey: .weaponList)
//        print(_weaponList)
//        let _bossKillCounts = try container.decodeIfPresent([BossCounts].self, forKey: .bossKillCounts) ?? [BossCounts()]
        let _weaponList = try container.decodeIfPresent([WeaponList].self, forKey: .weaponList) ?? [WeaponList()]
        print(_weaponList)
        weaponList.append(objectsIn: _weaponList.map{ Int($0.id).intValue })
        let _specialCount = try container.decodeIfPresent([Int].self, forKey: .specialCount) ?? [Int()]
        specialCount.append(objectsIn: _specialCount)
    }
}

class WeaponList: Codable {
    var id: String = "0"
    var weapon: [String: String] = [:]
}

class BossCounts: Codable {
    var id: String = "0"
    var count: Int = 0
}
