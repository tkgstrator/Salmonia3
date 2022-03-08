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
    /// 固有ID
    @Persisted(primaryKey: true) var id: String
    /// 金イクラ数
    @Persisted var goldenIkuraNum: Int
    /// 赤イクラ数
    @Persisted var ikuraNum: Int
    /// 金イクラドロップ数
    @Persisted var goldenIkuraPopNum: Int
    /// プレイヤー一覧
    @Persisted var members: List<String>
    /// シフトID
    @Persisted var playTime: Int
    /// 潮位
    @Persisted var waterLevel: WaterKey
    /// イベント
    @Persisted var eventType: EventKey
    /// WAVEID
    @Persisted var waveNum: Int
    /// バックリンク
    @Persisted(originProperty: "waves") private var link: LinkingObjects<RealmCoopShift>
    
    convenience init(result: FSCoopWave) {
        self.init()
        self.id = result.id
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.waveNum = result.waveNum
        self.members.append(objectsIn: result.members)
        self.playTime = result.playTime
        self.eventType = result.eventType
        self.waterLevel = result.waterLevel
    }
}

final class RealmStatsTotal: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    /// 金イクラ数
    @Persisted var goldenEggs: Int
    /// 赤イクラ数
    @Persisted var powerEggs: Int
    /// プレイヤー一覧
    @Persisted var members: List<String>
    /// シフトID
    @Persisted var playTime: Int
    /// 潮位
    @Persisted var waterLevel: List<WaterKey>
    /// イベント
    @Persisted var eventType: List<EventKey>
    /// オオモノ出現数
    @Persisted var bossCounts: List<Int>
    /// オオモノ討伐数
    @Persisted var bossKillCounts: List<Int>
    /// 失敗したWAVE
    @Persisted var failureWave: Int?
    /// 失敗した理由
    @Persisted var failureReason: FailureReason?
    /// クリアしたかどうか
    @Persisted var isClear: Bool
    /// バックリンク
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
