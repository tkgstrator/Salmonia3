//
//  Record.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//

import Foundation
import SplatNet2
import CryptoKit

struct FSRecordWave: FSCodable {
    let salmonId: Int
    let startTime: Int
    let ikuraNum: Int
    let goldenIkuraNum: Int
    let eventType: EventKey
    let waterLevel: WaterKey
    let waveId: Int?
    let members: [String]
    
    init(from result: Result.Response, wave: Result.WaveDetail, salmonId: Int) {
        self.salmonId = salmonId
        self.startTime = result.startTime
        self.ikuraNum = wave.ikuraNum
        self.goldenIkuraNum = wave.goldenIkuraNum
        self.eventType = wave.eventType.key
        self.waterLevel = wave.waterLevel.key
        self.waveId = result.waveDetails.firstIndex(of: wave)
        let players: [Result.PlayerResult] = [result.myResult] + (result.otherResults ?? [])
        self.members = players.map({ $0.pid }).sorted()
    }
}

extension Result.WaveDetail: Equatable {
    public static func == (lhs: Result.WaveDetail, rhs: Result.WaveDetail) -> Bool {
        (lhs.eventType.key == rhs.eventType.key) && (lhs.waterLevel.key == rhs.waterLevel.key) && (lhs.quotaNum == rhs.quotaNum) &&
        (lhs.goldenIkuraNum == rhs.goldenIkuraNum) && (lhs.ikuraNum == rhs.ikuraNum) && (lhs.goldenIkuraPopNum == rhs.goldenIkuraPopNum)
    }
    
}

extension FSRecordWave: Identifiable {
    // SalmonIdのSHA1を計算してIDとする
    var id: String {
        let plainText: String = String(format: "%08X%01X", salmonId, waveId ?? 0)
        return Insecure.SHA1.hash(data: Data(plainText.utf8))
            .compactMap({ String(format: "%02X", $0) }).joined()
    }
}
