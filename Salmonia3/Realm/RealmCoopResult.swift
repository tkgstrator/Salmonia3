//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2
import CodableDictionary

final class RealmCoopResult: Object {
    /// プレイヤーID
    @Persisted var pid: String
    /// バイトID
    @Persisted var jobId: Int?
    /// Salmon StatsID
    @Persisted var salmonId: Int?
    /// 評価レート
    @Persisted var gradePoint: Int?
    /// 増減評価レート
    @Persisted var gradePointDelta: Int?
    /// 失敗したWAVE
    @Persisted var failureWave: Int?
    /// バイトスコア
    @Persisted var jobScore: Int?
    /// 評価
    @Persisted var gradeId: GradeId?
    /// クマサンポイント
    @Persisted var kumaPoint: Int?
    /// キケン度
    @Persisted var dangerRate: Double
    /// 遊んだ時間
    @Persisted(primaryKey: true) var playTime: Int
    /// スケジュールID
    @Persisted(indexed: true) var startTime: Int
    /// 合計金イクラ
    @Persisted var goldenEggs: Int
    /// 合計赤イクラ
    @Persisted var powerEggs: Int
    /// 失敗理由
    @Persisted var failureReason: FailureReason?
    /// クリアしたかどうか
    @Persisted var isClear: Bool
    /// 出現したオオモノのカウント
    @Persisted var bossCounts: List<Int>
    /// たおしたオオモノのカウント
    @Persisted var bossKillCounts: List<Int>
    /// WAVE情報
    @Persisted var wave: List<RealmCoopWave>
    /// Player情報
    @Persisted var player: List<RealmCoopPlayer>
    /// バックリンク
    @Persisted(originProperty: "results") private var link: LinkingObjects<RealmCoopShift>
    
    convenience init(dummy: Bool = false) {
        self.init()
        self.pid = "0000000000000000"
        self.jobId = 0
        self.salmonId = 0
        self.gradePoint = 999
        self.gradePointDelta = 0
        self.failureWave = nil
        self.jobScore = 999
        self.gradeId = .profreshional
        self.kumaPoint = 999
        self.dangerRate = 200.0
        self.playTime = 0
        self.startTime = 0
        self.goldenEggs = 999
        self.powerEggs = 9999
        self.failureReason = nil
        self.isClear = true
        self.bossCounts.append(objectsIn: Array(repeating: 99, count: 9))
        self.wave.append(objectsIn: [RealmCoopWave(dummy: true)])
        self.player.append(objectsIn: [RealmCoopPlayer(dummy: true), RealmCoopPlayer(dummy: true), RealmCoopPlayer(dummy: true), RealmCoopPlayer(dummy: true)])
        self.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 9))
    }
    
    convenience init(result: FSCoopResult) {
        self.init()
        self.pid = result.myResult.pid
        self.jobId = result.jobId
        self.salmonId = result.salmonId
        self.gradePoint = {
            if let gradePoint = result.gradePoint, let gradeId = result.grade {
                return gradePoint - (gradeId - 1) * 100
            }
            return nil
        }()
        self.gradePointDelta = result.gradePointDelta
        self.failureWave = result.jobResult.failureWave
        self.jobScore = result.jobScore
        self.gradeId = GradeId(statsValue: result.grade)
        self.kumaPoint = result.kumaPoint
        self.dangerRate = NSDecimalNumber(decimal: result.dangerRate).doubleValue
        self.playTime = result.playTime
        self.startTime = result.startTime
        self.goldenEggs = ([result.myResult] + result.otherResults).map({ $0.goldenIkuraNum }).reduce(0, +)
        self.powerEggs = ([result.myResult] + result.otherResults).map({ $0.ikuraNum }).reduce(0, +)
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.bossCounts.append(objectsIn: result.bossCounts)
        self.wave.append(objectsIn: result.waveDetails.map({ RealmCoopWave(from: $0) }))
        let playerResult: [FSCoopPlayer] = [result.myResult] + result.otherResults
        let bossKillCounts: [Int] = playerResult.map({ $0.bossKillCounts }).sum()
        self.player.append(objectsIn: playerResult.map({ RealmCoopPlayer(from: $0) }))
        self.bossKillCounts.append(objectsIn: bossKillCounts)
    }
    
    convenience init(from result: CoopResult.Response, id: Int) {
        self.init()
        self.pid = result.myResult.pid
        self.jobId = result.jobId
        self.salmonId = id
        self.gradePoint = result.gradePoint
        self.gradePointDelta = result.gradePointDelta
        self.failureWave = result.jobResult.failureWave
        self.jobScore = result.jobScore
        self.gradeId = result.grade?.id
        self.kumaPoint = result.kumaPoint
        self.dangerRate = result.dangerRate
        self.playTime = result.playTime
        self.startTime = result.startTime
        let playerResult: [CoopResult.PlayerResult] = [result.myResult] + (result.otherResults ?? [])
        self.goldenEggs = playerResult.totalGoldenIkuraNum
        self.powerEggs = playerResult.totalIkuraNum
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.bossCounts.append(objectsIn: result.bossCounts.sortedValue())
        self.wave.append(objectsIn: result.waveDetails.map({ RealmCoopWave(from: $0) }))
        let bossKillCounts: [Int] = playerResult.map({ $0.bossKillCounts.sortedValue() }).sum()
        self.player.append(objectsIn: playerResult.map({ RealmCoopPlayer(from: $0) }))
        self.bossKillCounts.append(objectsIn: bossKillCounts)
    }
}

extension CodableDictionary where Key == BossId, Value == CoopResult.BossCount {
    func sortedValue() -> [Int] {
        self.sorted(by: { $0.key.rawValue < $1.key.rawValue }).map({ $0.value.count })
    }
}

extension CoopResult.Schedule {
    var stageId: StageId {
        switch self.stage.image {
        case .shakeup:
            return .shakeup
        case .shakeship:
            return .shakeship
        case .shakehouse:
            return .shakehouse
        case .shakelift:
            return .shakelift
        case .shakeride:
            return .shakeride
        }
    }
}

extension GradeId: PersistableEnum {}

extension FailureReason: PersistableEnum{}

extension Array where Element == CoopResult.PlayerResult {
    /// 残りのメンバーの金イクラの合計
    var totalGoldenIkuraNum: Int {
        self.map({ $0.goldenIkuraNum }).reduce(0, +)
    }
    
    /// 残りのメンバーの金イクラの合計
    var totalIkuraNum: Int {
        self.map({ $0.ikuraNum }).reduce(0, +)
    }
}

extension RealmCoopResult: Identifiable {
    public var id: Int { playTime }
}

extension Array where Element: Numeric  {
    func add<T: Numeric>(_ input: Array<T>) -> Array<T> {
        return zip(self as! [T], input).map({ $0.0 + $0.1 })
    }
}

extension Collection where Element == [Int]{
    func sum() -> [Int] {
        if let first = self.first {
            var sum: [Int] = Array(repeating: 0, count: first.count)
            let _ = self.map({ sum = sum.add($0) })
            return sum
        }
        return []
    }
}

extension RealmCoopResult {
    var stageId: StageId {
        schedule?.stageId ?? .shakeup
    }
    
    var schedule: RealmCoopShift? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime })
    }
}
