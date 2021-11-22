//
//  RealmCoopWave.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmCoopWave: Object, ObjectKeyIdentifiable {
    @Persisted var eventType: EventType
    @Persisted var waterLevel: WaterLevel
    @Persisted(indexed: true) var goldenIkuraNum: Int
    @Persisted var goldenIkuraPopNum: Int
    @Persisted var quotaNum: Int
    @Persisted var ikuraNum: Int
    @Persisted(originProperty: "wave") var result: LinkingObjects<RealmCoopResult>
//
//    convenience init(from result: SplatNet2.Coop.ResultWave) {
//        self.init()
//        self.eventType = EventType(rawValue: result.eventType)!
//        self.waterLevel = WaterLevel(rawValue: result.waterLevel)!
//        self.goldenIkuraNum = result.goldenIkuraNum
//        self.goldenIkuraPopNum = result.goldenIkuraPopNum
//        self.quotaNum = result.quotaNum
//        self.ikuraNum = result.ikuraNum
//    }
}

extension RealmCoopWave: Identifiable {
    /// 識別用のID
    var id: Int { self.quotaNum }
}

