//
//  FSCoopWave.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation
import SplatNet2
import CryptoKit
import FirebaseFirestore
import FirebaseFirestoreSwift

/// WAVE記録
struct FSCoopWave: Firecode {
    /// 金イクラ数
    let goldenIkuraNum: Int
    /// 赤イクラ数
    let ikuraNum: Int
    /// 金イクラドロップ数
    let goldenIkuraPopNum: Int
    /// プレイヤー一覧
    let members: [String]
    /// 遊んだ時間
    let playTime: Int
    /// シフトID
    let startTime: Int
    /// 潮位
    let waterLevel: WaterKey
    /// イベント
    let eventType: EventKey
    /// 第何WAVEか
    let waveNum: Int
    
    init(result: CoopResult.WaveDetail, members: [String], playTime: Int, startTime: Int, index: Int) {
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.members = members.sorted(by: <)
        self.playTime = playTime
        self.startTime = startTime
        self.waterLevel = result.waterLevel.key
        self.eventType = result.eventType.key
        self.waveNum = index
    }
    
    init(result: RealmCoopWave) {
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.members = result.result.player.map({ $0.pid }).sorted(by: <)
        self.playTime = result.result.playTime
        self.startTime = result.result.startTime
        self.waterLevel = result.waterLevel
        self.eventType = result.eventType
        self.waveNum = result.result.wave.firstIndex(of: result) ?? 0
    }
}

/// 総合記録
struct FSCoopTotal: Firecode {
    /// チーム総合金イクラ
    let goldenEggs: Int
    /// チーム総赤イクラ
    let powerEggs: Int
    /// プレイヤー一覧
    let members: [String]
    /// プレイ時間
    let playTime: Int
    /// シフトID
    let startTime: Int
    /// 潮位
    let waterLevel: [WaterKey]
    /// イベント
    let eventType: [EventKey]
    /// オオモノ討伐数
    let bossKillCounts: [Int]
    /// オオモノ出現数
    let bossCounts: [Int]
    /// 失敗したWAVE
    let failureWave: Int?
    /// 失敗原因
    let failureReason: FailureReason?
    /// クリアしたかどうか
    let isClear: Bool
    
    init(result: CoopResult.Response) {
        self.goldenEggs = result.waveDetails.map({ $0.goldenIkuraNum }).reduce(0, +)
        self.powerEggs = result.waveDetails.map({ $0.ikuraNum }).reduce(0, +)
        self.members = result.members
        self.startTime = result.startTime
        self.playTime = result.playTime
        self.waterLevel = result.waveDetails.map({ $0.waterLevel.key})
        self.eventType = result.waveDetails.map({ $0.eventType.key })
        self.bossCounts = result.bossCounts.sortedValue()
        self.failureWave = result.jobResult.failureWave
        self.failureReason = result.jobResult.failureReason
        self.bossKillCounts = result.playerResults.map({ $0.bossKillCounts.sortedValue() }).sum()
        self.isClear = result.jobResult.isClear
    }
    
    init(result: RealmCoopResult) {
        self.goldenEggs = result.goldenEggs
        self.powerEggs = result.powerEggs
        self.members = result.player.map({ $0.pid })
        self.startTime = result.startTime
        self.playTime = result.playTime
        self.waterLevel = result.wave.map({ $0.waterLevel })
        self.eventType = result.wave.map({ $0.eventType })
        self.bossCounts = Array(result.bossCounts)
        self.failureWave = result.failureWave
        self.failureReason = result.failureReason
        self.isClear = result.isClear
        self.bossKillCounts = Array(result.bossKillCounts)
    }
}

struct FSCoopResult: Firecode {
    /// バイトID
    let jobId: Int?
    /// バイトスコア
    let jobScore: Int?
    /// ウデマエ
    let grade: GradeId?
    /// 獲得クマサンポイント
    let kumaPoint: Int?
    /// レート
    let gradePoint: Int?
    /// レート増減
    let gradePointDelta: Int?
    /// キケン度
    let dangerRate: Double
    /// オオモノ出現数
    let bossCounts: [Int]
    /// オオモノ討伐数
    let bossKillCounts: [Int]
    /// Wave情報
    let waveDetails: [WaveDetail]
    /// プレイヤーリザルト
    let playerResults: [PlayerResult]
    /// ジョブリザルト
    let jobResult: CoopResult.JobResult
    /// スケジュール
    let schedule: Schedule
    /// プレイ時間
    let playTime: Int
    
    struct Schedule: Codable {
        let stageId: StageId
        let weapons: [WeaponType]
        let startTime: Int
        let endTime: Int
        
        init(schedule: CoopResult.Schedule) {
            self.stageId = schedule.stageId
            self.weapons = schedule.weapons.map({ $0.weaponId })
            self.startTime = schedule.startTime
            self.endTime = schedule.endTime
        }
    }
    
    struct PlayerResult: Codable {
        let pid: String
        let specialCounts: [Int]
        let goldenIkuraNum: Int
        let bossKillCounts: [Int]
        let special: SpecialId
        let deadCount: Int
        let name: String?
        let ikuraNum: Int
        let helpCount: Int
        let weaponList: [WeaponType]
        
        init(result: CoopResult.PlayerResult) {
            self.pid = result.pid
            self.specialCounts = result.specialCounts
            self.goldenIkuraNum = result.goldenIkuraNum
            self.bossKillCounts = result.bossKillCounts.sortedValue()
            self.special = result.special.id
            self.deadCount = result.deadCount
            self.name = result.name
            self.ikuraNum = result.ikuraNum
            self.helpCount = result.helpCount
            self.weaponList = result.weaponList.map({ $0.weaponId })
        }
    }
    
    struct WaveDetail: Codable {
        let ikuraNum: Int
        let goldenIkuraNum: Int
        let quotaNum: Int
        let goldenIkuraPopNum: Int
        let waterLevel: WaterKey
        let eventType: EventKey
        
        init(wave: CoopResult.WaveDetail) {
            self.ikuraNum = wave.ikuraNum
            self.goldenIkuraNum = wave.goldenIkuraNum
            self.quotaNum = wave.quotaNum
            self.goldenIkuraPopNum = wave.goldenIkuraPopNum
            self.waterLevel = wave.waterLevel.key
            self.eventType = wave.eventType.key
        }
    }
    
    init(result: CoopResult.Response) {
        self.jobId = result.jobId
        self.jobScore = result.jobScore
        self.grade = result.grade?.id
        self.kumaPoint = result.kumaPoint
        self.gradePoint = result.gradePoint
        self.gradePointDelta = result.gradePointDelta
        self.dangerRate = result.dangerRate
        self.bossCounts = result.bossCounts.sortedValue()
        self.bossKillCounts = result.bossKillCounts
        self.waveDetails = result.waveDetails.map({ WaveDetail(wave: $0) })
        self.playerResults = result.playerResults.map({ PlayerResult(result: $0) })
        self.jobResult = result.jobResult
        self.schedule = Schedule(schedule: result.schedule)
        self.playTime = result.playTime
    }
}

extension CoopResult.Response {
    var members: [String] {
        playerResults.map({ $0.pid })
    }
    
    var bossKillCounts: [Int] {
        playerResults.map({ $0.bossKillCounts.sortedValue() }).sum()
    }
}

extension FSCoopWave {
    internal var id: String {
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "@%d", members.joined(), offset)
        return SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
    }
    
    var reference: DocumentReference {
        Firestore
            .firestore()
            .collection("schedules")
            .document("\(self.startTime)")
            .collection(Self.path)
            .document(self.id)
    }
    
    static var path: String {
        "waves"
    }
}

extension FSCoopTotal {
    internal var id: String {
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "@%d", members.joined(), offset)
        return SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
    }
    
    var reference: DocumentReference {
        Firestore
            .firestore()
            .collection("schedules")
            .document("\(self.startTime)")
            .collection(Self.path)
            .document(self.id)
    }
    
    static var path: String {
        "total"
    }
}


extension FSCoopResult {
    internal var id: String {
        String(self.playTime)
    }
    private var documentId: String {
        // swiftlint:disable force_unwrapping
        playerResults.first!.pid
    }
    
    var reference: DocumentReference {
        Firestore
            .firestore()
            .collection("users")
            .document(self.documentId)
            .collection("results")
            .document(self.id)
    }
    
    static var path: String {
        "users"
    }
}
