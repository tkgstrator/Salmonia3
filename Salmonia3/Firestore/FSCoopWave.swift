//
//  FSCoopWave.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/18.
//

import Foundation
import SplatNet2
import SalmonStats

public struct FSCoopWave: Codable {
    public let ikuraNum: Int
    public let goldenIkuraNum: Int
    public let goldenIkuraPopNum: Int
    public let quotaNum: Int
    public let waterLevel: WaterId
    public let eventType: EventId
    
    public init(wave: CoopResult.WaveDetail) {
        self.ikuraNum = wave.ikuraNum
        self.goldenIkuraNum = wave.goldenIkuraNum
        self.goldenIkuraPopNum = wave.goldenIkuraPopNum
        self.quotaNum = wave.quotaNum
        self.eventType = wave.eventType.rawValue
        self.waterLevel = wave.waterLevel.rawValue
    }
}

public struct ResultCoopWave: Codable {
    public let ikuraNum: Int
    public let goldenIkuraNum: Int
    public let goldenIkuraPopNum: Int
    public let quotaNum: Int
    public let waterLevel: WaterId
    public let eventType: EventId
    /// 追加要素
    public let waveNum: Int
    public let isClear: Bool
    public let members: [String]

    public init(result: CoopResult.Response, wave: CoopResult.WaveDetail) {
        self.ikuraNum = wave.ikuraNum
        self.goldenIkuraNum = wave.goldenIkuraNum
        self.goldenIkuraPopNum = wave.goldenIkuraPopNum
        self.quotaNum = wave.quotaNum
        self.eventType = wave.eventType.rawValue
        self.waterLevel = wave.waterLevel.rawValue
        self.waveNum = result.waveDetails.firstIndex(of: wave) ?? 0
        self.members = result.playerResults.map({ $0.pid }).sorted()
        self.isClear = result.jobResult.isClear
    }
}
