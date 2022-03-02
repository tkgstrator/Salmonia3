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
import CodableDictionary

final class RealmCoopResult: Object {
    /// プレイヤーID
    @Persisted var pid: String
    /// バイトID
    @Persisted var jobId: Int?
    /// ステージID
    @Persisted var stageId: StageType.StageId
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
    /// シフト終了時間
    @Persisted var endTime: Int
    /// シフト開始時間
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
    
    convenience init(from result: CoopResult.Response, id: Int) {
        self.init()
        self.pid = result.myResult.pid
        self.jobId = result.jobId
        self.stageId = result.schedule.stage.image.stageId
        self.salmonId = id
        self.gradePoint = result.gradePoint
        self.gradePointDelta = result.gradePointDelta
        self.failureWave = result.jobResult.failureWave
        self.jobScore = result.jobScore
        self.gradeId = result.grade?.id
        self.kumaPoint = result.kumaPoint
        self.dangerRate = result.dangerRate
        self.playTime = result.playTime
        self.endTime = result.endTime
        self.startTime = result.startTime
        self.goldenEggs = result.myResult.goldenIkuraNum + (result.otherResults?.totalGoldenIkuraNum ?? 0)
        self.powerEggs = result.myResult.ikuraNum + (result.otherResults?.totalIkuraNum ?? 0)
        self.failureReason = result.jobResult.failureReason
        self.isClear = result.jobResult.isClear
        self.bossCounts.append(objectsIn: result.bossCounts.sortedValue())
        self.wave.append(objectsIn: result.waveDetails.map({ RealmCoopWave(from: $0) }))
        let playerResult: [CoopResult.PlayerResult] = [result.myResult] + (result.otherResults ?? [])
        let bossKillCounts: [Int] = playerResult.map({ $0.bossKillCounts.sortedValue() }).sum()
        self.player.append(objectsIn: playerResult.map({ RealmCoopPlayer(from: $0) }))
        self.bossKillCounts.append(objectsIn: bossKillCounts)
    }
}

extension CodableDictionary where Key == BossType, Value == CoopResult.BossCount {
    func sortedValue() -> [Int] {
        self.sorted(by: { $0.key.bossId.rawValue < $1.key.bossId.rawValue }).map({ $0.value.count })
    }
}

extension StageType {
    public enum StageId: Int, Codable, CaseIterable, PersistableEnum {
        case shakeup = 5000
        case shakeship = 5001
        case shakehouse = 5002
        case shakelift = 5003
        case shakeride = 5004
    }
}

extension BossType {
    enum BossId: Int, CaseIterable {
        case goldie = 3
        case steelhead = 6
        case flyfish = 9
        case scrapper = 12
        case steelEel = 13
        case stinger = 14
        case maws = 15
        case griller = 16
        case drizzler = 21
    }
}

extension BossType {
    var bossId: BossType.BossId {
        switch self {
        case .goldie:
            return .goldie
        case .steelhead:
            return .steelhead
        case .flyfish:
            return .flyfish
        case .scrapper:
            return .scrapper
        case .steelEel:
            return .steelEel
        case .stinger:
            return .stinger
        case .maws:
            return .maws
        case .griller:
            return .griller
        case .drizzler:
            return .drizzler
        }
    }
}

extension StageType.Image {
    var stageId: StageType.StageId {
        switch self {
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

extension GradeId: PersistableEnum {
}

extension FailureReason: PersistableEnum{
}

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
    var schedule: RealmCoopShift? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime })
    }
}
