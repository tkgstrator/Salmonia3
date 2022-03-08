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

final class RealmCoopWave: Object {
    @Persisted var eventType: EventKey
    @Persisted var waterLevel: WaterKey
    @Persisted(indexed: true) var goldenIkuraNum: Int
    @Persisted var goldenIkuraPopNum: Int
    @Persisted var quotaNum: Int
    @Persisted var ikuraNum: Int
    @Persisted(originProperty: "wave") private var link: LinkingObjects<RealmCoopResult>
    
    convenience init(from result: CoopResult.WaveDetail) {
        self.init()
        self.eventType = result.eventType.key
        self.waterLevel = result.waterLevel.key
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
}

extension RealmCoopWave {
    var result: RealmCoopResult {
        self.link.first!
    }
}

extension EventKey: PersistableEnum {}

extension WaterKey: PersistableEnum {}

//
extension RealmCoopWave: Identifiable {
    /// 識別用のID
    var id: Int { self.hash }
}

