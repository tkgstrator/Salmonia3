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
    @Persisted var eventType: String
    @Persisted var waterLevel: String
    @Persisted(indexed: true) var goldenIkuraNum: Int
    @Persisted var goldenIkuraPopNum: Int
    @Persisted var quotaNum: Int
    @Persisted var ikuraNum: Int
    @Persisted(originProperty: "wave") var result: LinkingObjects<RealmCoopResult>

    convenience init(from result: SplatNet2.Coop.ResultWave) {
        self.init()
        self.eventType = SplatNet2Metadata.EventType(rawValue: result.eventType)!.eventType
        self.waterLevel = SplatNet2Metadata.WaterLevel(rawValue: result.waterLevel)!.waterLevel
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
}

fileprivate final class SplatNet2Metadata {
    enum EventType: Int {
        case noevent = 0
        case rush = 1
        case goldie = 2
        case griller = 3
        case mothership = 4
        case fog = 5
        case cohock = 6
    }
    
    enum WaterLevel: Int {
        case low = 0
        case normal = 1
        case high = 2
    }
}

fileprivate extension SplatNet2Metadata.EventType {
    var eventType: String {
        switch self {
        case .noevent:
            return "water-levels"
        case .rush:
            return "rush"
        case .goldie:
            return "goldie-seeking"
        case .griller:
            return "griller"
        case .mothership:
            return "the-mothership"
        case .fog:
            return "fog"
        case .cohock:
            return "cohock-charge"
        }
    }
}

fileprivate extension SplatNet2Metadata.WaterLevel {
    var waterLevel: String {
        switch self {
        case .low:
            return "low"
        case .normal:
            return "normal"
        case .high:
            return "high"
        }
    }
}

extension RealmCoopWave {
    var weaponLists: [Int] {
        let startTime = self.result.first!.startTime
        return Array(RealmManager.shared.shift(startTime: startTime).weaponList)
    }
    
    var players: [RealmPlayer] {
        Array(RealmManager.shared.findPlayers(pid: self.result.first!.player.map({ $0.pid }).sorted()))
    }
    
    var playTime: Int {
        self.result.first!.playTime
    }
}

extension RealmCoopWave: Identifiable {
    var id: String { UUID().uuidString }
}
