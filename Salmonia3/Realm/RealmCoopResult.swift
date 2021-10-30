//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmCoopResult: Object {
    /// プレイヤーID
    @Persisted var pid: String
    /// バイトID
    @Persisted var jobId: Int?
    /// ステージID
    @Persisted var stageId: StageType
    @Persisted var salmonId: Int?
    @Persisted var gradePoint: Int?
    @Persisted var gradePointDelta: Int?
    @Persisted var failureWave: Int?
    @Persisted var jobScore: Int?
    @Persisted var gradeId: GradeType
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
    @Persisted var player: List<RealmCoopPlayer>

    convenience init(from result: SplatNet2.Coop.Result, pid: String) {
        self.init()
        self.stageId = StageType(rawValue: result.stageId)!
        self.jobId = result.jobId
        self.failureWave = result.jobResult.failureWave
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.pid = pid
        self.jobScore = result.jobScore
        self.kumaPoint = result.kumaPoint
        self.gradePoint = result.gradePoint
        if let grade = result.grade, let gradeId = GradeType(rawValue: grade) {
            self.gradeId = gradeId
        } else {
            self.gradeId = .intern
        }
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
        self.player.append(objectsIn: result.results.map{ RealmCoopPlayer(from: $0) })
    }
}

extension RealmCoopResult: Identifiable {
    public var id: Int { playTime }
}

extension RealmCoopResult {
//    var indexOfResults: Int {
//        return (RealmManager.shared.results(startTime: startTime).sorted(byKeyPath: "playTime", ascending: true).index(of: self) ?? -1) + 1
//    }
//    
//    var players: [RealmPlayer] {
//        Array(RealmManager.shared.findPlayers(pid: self.player.map({ $0.pid }).sorted()))
//    }
//    
//    var weaponList: [Int] {
//        Array(RealmManager.shared.shift(startTime: self.startTime).weaponList)
//    }
}
