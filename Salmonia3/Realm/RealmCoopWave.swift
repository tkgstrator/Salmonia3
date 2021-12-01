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
    @Persisted var eventType: Result.EventKey
    @Persisted var waterLevel: Result.WaterKey
    @Persisted(indexed: true) var goldenIkuraNum: Int
    @Persisted var goldenIkuraPopNum: Int
    @Persisted var quotaNum: Int
    @Persisted var ikuraNum: Int
    @Persisted(originProperty: "wave") var result: LinkingObjects<RealmCoopResult>
    
    convenience init(from result: Result.WaveDetail) {
        self.init()
        self.eventType = result.eventType.key
        self.waterLevel = result.waterLevel.key
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
}

extension Result.EventKey: PersistableEnum, Identifiable {
    public var id: String { rawValue }
}

extension Result.WaterKey: PersistableEnum, Identifiable {
    public var id: String { rawValue }
}

//
extension RealmCoopWave: Identifiable {
    /// 識別用のID
    var id: Int { self.quotaNum }
}

