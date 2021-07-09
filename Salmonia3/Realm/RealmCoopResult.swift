//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
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

    convenience init(from result: SplatNet2.Coop.Result, pid: String) {
        self.init()
        self.stageId = result.stageId
        self.jobId = result.jobId
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
    
    convenience init(from result: SalmonStats.ResultCoop, pid: String) {
        self.init()
        self.stageId = result.stageId
        self.salmonId = result.jobId
        self.failureWave = result.jobResult.failureWave
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.pid = pid
        if let gradePoint = result.results.filter({ $0.pid == pid }).first?.gradePoint {
            self.gradePoint = gradePoint.gradePointValue
            self.gradeId = gradePoint.gradeIdValue
        }
        self.dangerRate = result.dangerRate
        self.playTime = result.time.playTime
        self.endTime = result.time.endTime
        self.startTime = result.time.startTime
        self.goldenEggs = result.waveDetails.map{ $0.goldenIkuraNum }.reduce(0, +)
        self.powerEggs = result.waveDetails.map{ $0.ikuraNum }.reduce(0, +)
        self.bossCounts.append(objectsIn: result.bossCounts)
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.wave.append(objectsIn: result.waveDetails.map{ RealmCoopWave(from: $0) })
        self.player.append(objectsIn: result.results.map{ RealmPlayerResult(from: $0) })
    }
}

private extension Int {
    var gradeIdValue: Int? {
        switch self {
        case 0 ..< 100:
            return 1
        case 100 ..< 200:
            return 2
        case 200 ..< 300:
            return 3
        case 300 ..< 400:
            return 4
        case 400 ..< 1400:
            return 5
        default:
            return nil
        }
    }
    
    var gradePointValue: Int? {
        switch self {
        case 0 ..< 100:
            return self
        case 100 ..< 200:
            return self - 100
        case 200 ..< 300:
            return self - 200
        case 300 ..< 400:
            return self - 300
        case 400 ..< 1400:
            return self - 400
        default:
            return nil
        }
    }
}

extension RealmCoopResult {
    var indexOfResults: Int {
        return (RealmManager.Objects.results(startTime: startTime).sorted(byKeyPath: "playTime", ascending: true).index(of: self) ?? -1) + 1
    }
}
