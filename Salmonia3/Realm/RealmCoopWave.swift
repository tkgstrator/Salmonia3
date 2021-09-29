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
    var weaponList: [Int] {
        guard let startTime = self.result.first?.startTime else { return [0, 0, 0, 0] }
        return Array(RealmManager.shared.shift(startTime: startTime).weaponList)
    }
    
    var players: [RealmPlayer] {
        guard let players = self.result.first?.player else { return [] }
        return Array(RealmManager.shared.findPlayers(pid: players.map({ $0.pid }).sorted()))
    }
    
    var playTime: Int {
        self.result.first!.playTime
    }
    
    var stage: StageType {
        guard let stageId = self.result.first?.stageId, let stage = StageType(rawValue: stageId) else { return .shakeup }
        return stage
    }
}

extension RealmCoopWave: Identifiable {
    var id: String { UUID().uuidString }
}
