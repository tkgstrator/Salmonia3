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

class RealmCoopResult: Object, Identifiable {
    @objc dynamic var pid: String?
    let jobId = RealmOptional<Int>() // SplatNet2用のID
    let stageId = RealmOptional<Int>()
    let salmonId = RealmOptional<Int>() // SalmonStats用のID
    let gradePoint = RealmOptional<Int>()
    let gradeId = RealmOptional<Int>()
    let gradePointDelta = RealmOptional<Int>()
    let failureWave = RealmOptional<Int>()
    let jobScore = RealmOptional<Int>()
    let kumaPoint = RealmOptional<Int>()
    let dangerRate = RealmOptional<Double>()
    @objc dynamic var playTime: Int = 0
    @objc dynamic var endTime: Int = 0
    @objc dynamic var startTime: Int = 0
    let goldenEggs = RealmOptional<Int>()
    let powerEggs = RealmOptional<Int>()
    @objc dynamic var failureReason: String?
    @objc dynamic var isClear: Bool = false
    dynamic var bossCounts = List<Int>()
    dynamic var bossKillCounts = List<Int>()
    var wave = List<RealmCoopWave>()
    var player = List<RealmPlayerResult>()

    override static func primaryKey() -> String? {
        return "playTime"
    }

    override static func indexedProperties() -> [String] {
        return ["startTime"]
    }

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
        self.stageId.value = result.stageId
        self.jobId.value = result.jobId
        self.failureWave.value = result.jobResult.failureWave
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.pid = pid
        self.jobScore.value = result.jobScore
        self.kumaPoint.value = result.kumaPoint
        self.gradePoint.value = result.gradePoint
        self.gradeId.value = result.grade
        self.gradePointDelta.value = result.gradePointDelta
        self.dangerRate.value = result.dangerRate
        self.playTime = result.time.playTime
        self.endTime = result.time.endTime
        self.startTime = result.time.startTime
        self.goldenEggs.value = result.goldenEggs
        self.powerEggs.value = result.powerEggs
        self.bossCounts.append(objectsIn: result.bossCounts)
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.wave.append(objectsIn: result.waveDetails.map{ RealmCoopWave(from: $0) })
        self.player.append(objectsIn: result.results.map{ RealmPlayerResult(from: $0) })
    }
    
    convenience init(from result: SalmonStats.ResultCoop, pid: String) {
        self.init()
        self.stageId.value = result.stageId
        self.salmonId.value = result.jobId
        self.failureWave.value = result.jobResult.failureWave
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.pid = pid
        if let gradePoint = result.results.filter({ $0.pid == pid }).first?.gradePoint {
            self.gradePoint.value = gradePoint.gradePointValue
            self.gradeId.value = gradePoint.gradeIdValue
        }
        self.dangerRate.value = result.dangerRate
        self.playTime = result.time.playTime
        self.endTime = result.time.endTime
        self.startTime = result.time.startTime
        self.goldenEggs.value = result.waveDetails.map{ $0.goldenIkuraNum }.reduce(0, +)
        self.powerEggs.value = result.waveDetails.map{ $0.ikuraNum }.reduce(0, +)
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
        let results = RealmManager.shared.realm.objects(RealmCoopResult.self).filter("startTime=%@", self.startTime)
        return (results.index(of: self) ?? -1) + 1
    }
}
