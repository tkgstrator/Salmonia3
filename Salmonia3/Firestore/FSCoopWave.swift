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
    /// 固有ID
    let id: String
    
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
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "@%d", members.joined(), offset)
        self.id = SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
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
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "@%d", members.joined(), offset)
        self.id = SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
    }
}

/// 総合記録
struct FSCoopTotal: Firecode {
    /// 固有ID
    let id: String
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
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "@%d", members.joined(), offset)
        self.id = SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
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
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "@%d", members.joined(), offset)
        self.id = SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
    }
}

extension CoopResult.Response {
    var members: [String] {
        [myResult.pid] + (otherResults?.map({ $0.pid }) ?? [])
    }
}

extension FSCoopWave {
    var reference: DocumentReference {
        Firestore
            .firestore()
            .collection("schedules")
            .document("\(self.startTime)")
            .collection("waves")
            .document(self.id)
    }
    
    static var path: String {
        "waves"
    }
}

extension FSCoopTotal {
    var reference: DocumentReference {
        Firestore
            .firestore()
            .collection("schedules")
            .document("\(self.startTime)")
            .collection("total")
            .document(self.id)
    }
    
    static var path: String {
        "total"
    }
}
