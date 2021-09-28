//
//  ShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/04.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI

class CoopShiftStats: ObservableObject {
    @Published var resultAvg: ResultAvg = ResultAvg()
    @Published var resultMax: ResultMax = ResultMax()
    @Published var overview: ResultOverview = ResultOverview()
    @Published var weapons: [ResultWeapon] = []
    @Published var specials: [ResultSpecial] = []
    @Published var resultWave: [ResultWave] = []
    private var token: NotificationToken?
    
    init() {}
    init(startTime: Int) {
        // 未来のシフトは何もせずにリターン
        if startTime >= Int(Date().timeIntervalSince1970) { return }
        // 現在選択されているプレイヤーのIDを取得
        let playerId: String = manager.account.nsaid
        // 必要なデータをRealmから取得
        let playerResults = RealmManager.shared.playerResults(startTime: startTime, playerId: playerId)
        // リザルト件数が0なら何もせずにリターン
        if playerResults.count == 0 { return }
        let allResults = RealmManager.shared.results(startTime: startTime, playerId: playerId)
        let waves = RealmManager.shared.waves(startTime: startTime)
        
        // 支給されたブキの情報
        let suppliedWeapons: [Int] = RealmManager.shared.playerResults(startTime: startTime).flatMap{ $0.weaponList }
        let weaponsList = RealmManager.shared.shift(startTime: startTime).weaponsList
        // そのブキが支給された回数を計算する
        self.weapons = weaponsList.map({ weaponId in
            let count = suppliedWeapons.count(weaponId)
            return ResultWeapon(weaponId: weaponId, count: count, prob: Double(count) / Double(suppliedWeapons.count))
        })

        // 支給されたスペシャルの情報
        let suppliedSpecials: [(Int, Int)] = RealmManager.shared.suppliedSpecial(startTime: startTime)
        self.specials = suppliedSpecials.map({ ResultSpecial(specialId: $0, count: $1, prob:  Double($1) / Double(suppliedSpecials.map({ $1 }).reduce(0, +))) }).sorted(by: { $0.count > $1.count })
        
        self.resultWave = waves.resultWaves
        self.resultMax = ResultMax(player: playerResults, result: allResults)
        self.resultAvg = ResultAvg(player: playerResults, result: allResults)
        self.overview = ResultOverview(player: playerResults, results: allResults)
    }
    
    class ResultOverview {
        /// バイト回数
        var jobNum: Int?
        /// 何に使ってるんこれ
        var player: RealmSwift.Results<RealmPlayerResult>?
        /// 平均クリア数
        var clearWave: Double?
        /// クリア率
        var clearRatio: Double?
        /// 金イクラ占有率
        var goldenEggRatio: Double?
        /// 赤イクラ占有率
        var powerEggRatio: Double?
        /// 野良マッチング率
        var crewAvg: Double?
        
        init() {}
        init(player: RealmSwift.Results<RealmPlayerResult>, results: RealmSwift.Results<RealmCoopResult>) {
            // リザルトが0件なら何もせずに戻る
            guard let _ = results.first else { return }
            self.player = player
            self.jobNum = results.count
            self.clearRatio = Double(results.filter("isClear=true").count) / Double(results.count)
            self.goldenEggRatio = player.sum(ofProperty: "goldenIkuraNum") / results.sum(ofProperty: "goldenEggs")
            self.powerEggRatio = player.sum(ofProperty: "ikuraNum") / results.sum(ofProperty: "powerEggs")
            
            // 野良率を計算するところ
            let players: [String] = results.flatMap({ $0.player.map({ $0.pid })})
            if results.count > 1 {
                self.crewAvg = 3 * Double(Set(players).count - 4) / Double(players.count - results.count - 3)
            }
        }
    }
    
    /// 支給さればブキを管理するクラス
    struct ResultWeapon: Hashable {
        let weaponId: Int
        let count: Int
        let prob: String
        
        init(weaponId: Int, count: Int, prob: Double) {
            self.weaponId = weaponId
            self.count = count
            self.prob = String(format: "%.1f%%", prob * 100)
        }
    }
    
    struct ResultSpecial: Hashable {
        static func == (lhs: CoopShiftStats.ResultSpecial, rhs: CoopShiftStats.ResultSpecial) -> Bool {
            lhs.specialId == rhs.specialId
        }
        
        let specialId: Int
        let count: Int
        let prob: String

        init(specialId: Int, count: Int, prob: Double) {
            self.specialId = specialId
            self.count = count
            self.prob = String(format: "%.2f%%", prob * 100)
        }
    }

    /// 納品数平均を扱うクラス
    class ResultWave {
        var waterLevel: WaterLevel
        var eventType: EventType
        var goldenIkuraAvg: Double?
        var goldenIkuraMax: Int?
        
        init(waterLevel: WaterLevel, eventType: EventType, goldenIkuraAvg: Double?, goldenIkuraMax: Int?) {
            self.waterLevel = waterLevel
            self.eventType = eventType
            self.goldenIkuraAvg = goldenIkuraAvg
            self.goldenIkuraMax = goldenIkuraMax
        }
    }
    
    /// 最高記録を求める
    class ResultMax {
        var teamPowerEggs: Int?
        var teamGoldenEggs: Int?
        var powerEggs: Int?
        var goldenEggs: Int?
        var bossDefeated: Int?
        var helpCount: Int?
        var deadCount: Int?
        
        init() {}
        init(player: RealmSwift.Results<RealmPlayerResult>, result: RealmSwift.Results<RealmCoopResult>) {
            guard let _ = result.first else { return }
            self.teamPowerEggs = result.max(ofProperty: "powerEggs")
            self.teamGoldenEggs = result.max(ofProperty: "goldenEggs")
            self.powerEggs = player.max(ofProperty: "ikuraNum")
            self.goldenEggs = player.max(ofProperty: "goldenIkuraNum")
            self.bossDefeated = player.map{ $0.bossKillCounts.sum() }.max()
            self.helpCount = player.max(ofProperty: "helpCount")
            self.deadCount = player.max(ofProperty: "deadCount")
        }
    }
    
    /// 平均記録を求める
    class ResultAvg {
        var teamPowerEggs: Double?
        var teamGoldenEggs: Double?
        var powerEggs: Double?
        var goldenEggs: Double?
        var bossDefeated: Double?
        var helpCount: Double?
        var deadCount: Double?
        
        init() {}
        init(player: RealmSwift.Results<RealmPlayerResult>, result: RealmSwift.Results<RealmCoopResult>) {
            guard let _ = result.first else { return }
            self.teamPowerEggs = result.average(ofProperty: "powerEggs")
            self.teamGoldenEggs = result.average(ofProperty: "goldenEggs")
            self.powerEggs = player.average(ofProperty: "ikuraNum")
            self.goldenEggs = player.average(ofProperty: "goldenIkuraNum")
            self.bossDefeated = player.map{ $0.bossKillCounts.sum() }.avg()
            self.helpCount = player.average(ofProperty: "helpCount")
            self.deadCount = player.average(ofProperty: "deadCount")
        }
    }
    
    class Salmonid {
        
    }
}

extension Array where Element == Int {
    func avg() -> Double? {
        if self.isEmpty { return nil }
        return Double(self.reduce(0, +)) / Double(self.count)
    }
    
    func count(_ element: Int) -> Int {
        return self.filter{ $0 == element }.count
    }
}

fileprivate extension RealmSwift.Results where Element == RealmCoopWave {
    var resultWaves: [CoopShiftStats.ResultWave] {
        var waves: [CoopShiftStats.ResultWave] = []
        for eventType in EventType.allCases {
            for waterLevel in WaterLevel.allCases {
                let results = self.filter("eventType=%@ AND waterLevel=%@", eventType.rawValue, waterLevel.rawValue)
                let goldenIkuraAvg: Double? = results.average(ofProperty: "goldenIkuraNum")
                let goldenIkuraMax: Int? = results.max(ofProperty: "goldenIkuraNum")
                waves.append(CoopShiftStats.ResultWave(waterLevel: waterLevel, eventType: eventType, goldenIkuraAvg: goldenIkuraAvg, goldenIkuraMax: goldenIkuraMax))
            }
        }
        return waves
    }
}
