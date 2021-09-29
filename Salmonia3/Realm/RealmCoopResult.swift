//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/12.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmCoopResult: Object, Identifiable {
    @Persisted var pid: String
    @Persisted var jobId: Int?
    @Persisted var stageId: Int
    @Persisted var salmonId: Int?
    @Persisted var gradePoint: Int?
    @Persisted var gradePointDelta: Int?
    @Persisted var failureWave: Int?
    @Persisted var jobScore: Int?
    @Persisted var gradeId: Int?
    @Persisted var kumaPoint: Int?
    @Persisted var dangerRate: Double
    @Persisted(primaryKey: true) var playTime: Int
    @Persisted var endTime: Int
    @Persisted(indexed: true) var startTime: Int
    @Persisted var goldenEggs: Int
    @Persisted var powerEggs: Int
    @Persisted var failureReason: String?
    @Persisted var isClear: Bool
    @Persisted var bossCounts: List<Int>
    @Persisted var bossKillCounts: List<Int>
    @Persisted var wave: List<RealmCoopWave>
    @Persisted var player: List<RealmPlayerResult>
    
    var specialUsage: [[Int]] {
        // ここのコードを修正予定
        var usage: [[Int]] = []
        for wave in Range(0 ... self.wave.count - 1) {
            var tmp: [Int] = []
            for player in self.player {
                tmp += [Int](repeating: player.specialId, count: player.specialCounts[wave])
            }
            usage.append(tmp)
        }
        return usage
    }
    
    convenience init(from result: SplatNet2.Coop.Result, pid: String, environment: RealmManager.Environment.Server = .splatnet2) {
        self.init()
        self.stageId = result.stageId
        switch environment {
        case .splatnet2:
            self.jobId = result.jobId
        case .salmonstats:
            self.salmonId = result.jobId
        }
        self.failureWave = result.jobResult.failureWave
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.pid = pid
        self.jobScore = result.jobScore
        self.kumaPoint = result.kumaPoint
        self.gradePoint = result.gradePoint
        self.gradeId = result.grade
        self.gradePointDelta = result.gradePointDelta
        self.dangerRate = result.dangerRate
        self.playTime = result.time.playTime
        self.endTime = result.time.endTime
        self.startTime = result.time.startTime
        self.goldenEggs = result.goldenEggs
        self.powerEggs = result.powerEggs
        self.bossCounts.append(objectsIn: result.bossCounts)
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.wave.append(objectsIn: result.waveDetails.map{ RealmCoopWave(from: $0) })
        self.player.append(objectsIn: result.results.map{ RealmPlayerResult(from: $0) })
    }
}

extension RealmCoopResult {
    var indexOfResults: Int {
        return (RealmManager.shared.results(startTime: startTime).sorted(byKeyPath: "playTime", ascending: true).index(of: self) ?? -1) + 1
    }
    
    var players: [RealmPlayer] {
        Array(RealmManager.shared.findPlayers(pid: self.player.map({ $0.pid }).sorted()))
    }
    
    var weaponList: [Int] {
        Array(RealmManager.shared.shift(startTime: self.startTime).weaponList)
    }
}
