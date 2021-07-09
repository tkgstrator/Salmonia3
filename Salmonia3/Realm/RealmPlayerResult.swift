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
    @Persisted var name: String?
    @Persisted(indexed: true) var pid: String
    @Persisted var deadCount: Int
    @Persisted var helpCount: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var ikuraNum: Int
    @Persisted var specialId: Int
    @Persisted var bossKillCounts: List<Int>
    @Persisted var weaponList: List<Int>
    @Persisted var specialCounts: List<Int>
    @Persisted(originProperty: "player") var result: LinkingObjects<RealmCoopResult>

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
