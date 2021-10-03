//
//  RealmCoopWave.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/12.
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

    convenience init(from result: SplatNet2.Coop.ResultWave) {
        self.init()
        self.eventType = EventType(rawValue: result.eventType)!
        self.waterLevel = WaterLevel(rawValue: result.waterLevel)!
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
    
    convenience init(from record: RealmStatsRecord) {
        self.init()
        self.eventType = record.eventType ?? .noevent
        self.waterLevel = record.waterLevel ?? .middle
        self.goldenIkuraNum = record.goldenEggs
        self.ikuraNum = record.powerEggs
        self.quotaNum = 0
        self.goldenIkuraPopNum = 0
    }
}

extension RealmCoopWave {
    /// 支給されたブキリスト
    var weaponList: [Int] {
        guard let startTime = self.result.first?.startTime else { return [0, 0, 0, 0] }
        return Array(RealmManager.shared.shift(startTime: startTime).weaponList)
    }
    
    /// 一緒に遊んだプレイヤーの詳細リスト
    var players: [RealmPlayer] {
        guard let players = self.result.first?.player else { return [] }
        return Array(RealmManager.shared.findPlayers(pid: players.map({ $0.pid }).sorted()))
    }

    /// 遊んだ時間
    var playTime: Int {
        guard let playTime = result.first?.playTime else { return 1500616800 }
        return playTime
    }
    
    /// 遊んだステージ
    var stage: StageType {
        guard let stageId = self.result.first?.stageId, let stage = StageType(rawValue: stageId) else { return .shakeup }
        return stage
    }
    
    /// 第何WAVEかを返す
    var index: Int {
        guard let result = self.result.first else { return 0 }
        guard let index = result.wave.firstIndex(where: { $0.quotaNum == self.quotaNum }) else { return 0 }
        return index
    }
    
    /// そのWAVEで使われたスペシャルを返す
    var specialUsage: [Int] {
        guard let result = self.result.first else { return [] }
        /// スペシャル使用回数を転置してそのWAVEでの使用回数を返す
        let usage = Array(result.player.map({ Array($0.specialCounts) })).transpose()[self.index]
        let player = result.player
        return usage.enumerated().flatMap({ Array(repeating: player[$0.offset].specialId, count: $0.element) })
    }
}

extension RealmCoopWave: Identifiable {
    /// 識別用のID
    var id: Int { self.quotaNum }
}
