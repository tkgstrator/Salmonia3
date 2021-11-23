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
    @Persisted var stageId: Result.StageType.StageId
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
    @Persisted var gradeId: Result.GradeId?
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
    @Persisted var failureReason: Result.FailureReason?
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
    
    convenience init(from result: Result.Response, nsaid: String) {
        self.init()
        self.pid = nsaid
        self.jobId = result.jobId
        self.stageId = result.schedule.stage.image.stageId
        self.salmonId = nil
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
        self.bossCounts.append(objectsIn: result.bossCounts.map({ $0.value.count }))
        self.wave.append(objectsIn: result.waveDetails.map({ RealmCoopWave(from: $0) }))
        let playerResult: [Result.PlayerResult] = [result.myResult] + (result.otherResults ?? [])
        self.player.append(objectsIn: playerResult.map({ RealmCoopPlayer(from: $0) }))
    }
}


extension Result.StageType {
    public enum StageId: Int, Codable, CaseIterable, PersistableEnum {
        case shakeup = 5000
        case shakeship = 5001
        case shakehouse = 5002
        case shakelift = 5003
        case shakeride = 5004
    }
}

extension Result.StageType.Image {
    var stageId: Result.StageType.StageId {
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

extension Result.GradeId: PersistableEnum {
}

extension Result.FailureReason: PersistableEnum{
}

extension Array where Element == Result.PlayerResult {
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
