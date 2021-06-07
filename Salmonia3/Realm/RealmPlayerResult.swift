//
//  RealmPlayerResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmPlayerResult: Object {
    @objc dynamic var name: String?
    @objc dynamic var pid: String?
    @objc dynamic var deadCount: Int = 0
    @objc dynamic var helpCount: Int = 0
    @objc dynamic var goldenIkuraNum: Int = 0
    @objc dynamic var ikuraNum: Int = 0
    @objc dynamic var specialId: Int = 0
    dynamic var bossKillCounts = List<Int>()
    dynamic var weaponList = List<Int>()
    dynamic var specialCounts = List<Int>()
    let result = LinkingObjects(fromType: RealmCoopResult.self, property: "player")

    override static func indexedProperties() -> [String] {
        return ["nsaid"]
    }

    public convenience init(from result: SplatNet2.Coop.ResultPlayer) {
        self.init()
        self.name = result.name
        self.pid = result.pid
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.specialId = result.specialId
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.weaponList.append(objectsIn: result.weaponList)
        self.specialCounts.append(objectsIn: result.specialCounts)
    }

    public convenience init(from result: SalmonStats.ResultCoop.ResultPlayer) {
        self.init()
        self.name = result.name
        self.pid = result.pid
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.specialId = result.specialId
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.weaponList.append(objectsIn: result.weaponList)
        self.specialCounts.append(objectsIn: result.specialCounts)
    }
}
