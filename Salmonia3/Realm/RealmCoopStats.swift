//
//  RealmCoopStats.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/03.
//

import Foundation
import RealmSwift
import SplatNet2

final class RealmStatsWave: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var goldenEggs: Int
    @Persisted var powerEggs: Int
    @Persisted var members: List<String>
    @Persisted var playTime: Int
    @Persisted var eventType: EventKey
    @Persisted var waterLevel: WaterKey
    @Persisted(originProperty: "waves") private var link: LinkingObjects<RealmCoopShift>
    
    convenience init(result: FSCoopWave) {
        self.init()
        self.id = result.id
        self.goldenEggs = result.goldenEggs
        self.powerEggs = result.powerEggs
        self.members.append(objectsIn: result.members)
        self.playTime = result.playTime
        self.eventType = result.eventType
        self.waterLevel = result.waterLevel
    }
}

final class RealmStatsTotal: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var goldenEggs: Int
    @Persisted var powerEggs: Int
    @Persisted var members: List<String>
    @Persisted var playTime: Int
    @Persisted var eventType: List<EventKey>
    @Persisted var waterLevel: List<WaterKey>
    @Persisted(originProperty: "total") private var link: LinkingObjects<RealmCoopShift>
    
    convenience init(result: FSCoopTotal) {
        self.init()
        self.id = result.id
        self.goldenEggs = result.goldenEggs
        self.powerEggs = result.powerEggs
        self.members.append(objectsIn: result.members)
        self.playTime = result.playTime
        self.eventType.append(objectsIn: result.eventType)
        self.waterLevel.append(objectsIn: result.waterLevel)
    }
}
