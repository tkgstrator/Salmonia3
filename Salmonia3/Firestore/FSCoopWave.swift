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
    let goldenEggs: Int
    let powerEggs: Int
    let members: [String]
    let playTime: Int
    let startTime: Int
    let waterLevel: WaterKey
    let eventType: EventKey
    let id: String
    
    init(result: CoopResult.WaveDetail, members: [String], playTime: Int, startTime: Int) {
        self.goldenEggs = result.goldenIkuraNum
        self.powerEggs = result.ikuraNum
        self.members = members
        self.playTime = playTime
        self.startTime = startTime
        self.waterLevel = result.waterLevel.key
        self.eventType = result.eventType.key
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "%d%d%@%d", powerEggs, goldenEggs, members.joined(), offset)
        self.id = SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
    }
    
    init(result: RealmCoopWave) {
        self.goldenEggs = result.goldenIkuraNum
        self.powerEggs = result.ikuraNum
        self.members = result.result.player.map({ $0.pid })
        self.playTime = result.result.playTime
        self.startTime = result.result.startTime
        self.waterLevel = result.waterLevel
        self.eventType = result.eventType
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "%d%d%@%d", powerEggs, goldenEggs, members.joined(), offset)
        self.id = SHA256.hash(data: encodedString.data(using: .utf8)!).compactMap({ String(format: "%02X", $0)}).joined()
    }
}

/// 総合記録
struct FSCoopTotal: Firecode {
    /// 識別用ID
    let id: String
    /// チーム総合金イクラ
    let goldenEggs: Int
    /// チーム総赤イクラ
    let powerEggs: Int
    /// メンバーのnsaid
    let members: [String]
    /// プレイ時間
    let playTime: Int
    /// シフト
    let startTime: Int
    /// 潮位
    let waterLevel: [WaterKey]
    /// イベント
    let eventType: [EventKey]
    // 追加
    /// オオモノ討伐数
//    let bossKillCounts: [Int]
    /// オオモノ出現数
//    let bossCounts: [Int]
    /// 失敗したWAVE
//    let failureWave: Int?
    /// 失敗原因
//    let failureReason: FailureReason?
    /// プレイヤーリザルト
//    let playerResults: [PlayerResult]
    
//    struct PlayerResult: Codable {
//        let goldenEggs: Int
//        let powerEggs: Int
//        let bossKillCounts: [Int]
//    }
    
    init(result: CoopResult.Response) {
        self.goldenEggs = result.waveDetails.map({ $0.goldenIkuraNum }).reduce(0, +)
        self.powerEggs = result.waveDetails.map({ $0.ikuraNum }).reduce(0, +)
        self.members = result.members
        self.startTime = result.startTime
        self.playTime = result.playTime
        self.waterLevel = result.waveDetails.map({ $0.waterLevel.key})
        self.eventType = result.waveDetails.map({ $0.eventType.key })
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "%d%d%@%d", powerEggs, goldenEggs, members.sorted().joined(), offset)
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
        let offset: Int = (playTime - startTime) / 100
        let encodedString: String = String(format: "%d%d%@%d", powerEggs, goldenEggs, members.sorted().joined(), offset)
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
