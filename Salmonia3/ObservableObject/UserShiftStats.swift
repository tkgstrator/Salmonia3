//
//  StatsModel.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import Surge
import SplatNet2
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class UserShiftStats: ObservableObject {
    internal let firestore: Firestore = Firestore.firestore()
    internal let encoder: Firestore.Encoder = Firestore.Encoder()
    internal let decoder: Firestore.Decoder = Firestore.Decoder()
    internal var task: Set<AnyCancellable> = Set<AnyCancellable>()
    internal let nsaid: String?

    typealias Overview = StatsModel.Overview
    typealias Defeated = StatsModel.Defeated
    typealias Comparison = StatsModel.Comparison
    typealias WeaponProb = StatsModel.WeaponProb
    typealias SpecialProb = StatsModel.SpecialProb

    /// 赤イクラ数
    var ikuraNum: [Overview] = []
    /// 金イクラ数
    var goldenIkuraNum: [Overview] = []
    /// 被救助数
    var deadCount: [Overview] = []
    /// 救助数
    var helpCount: [Overview] = []
    /// オオモノ討伐数
    var defeatedCount: [Overview] = []
    /// 各オオモノ討伐数
    var defeatedIdCount: [Defeated] = []
    /// チーム赤イクラ数
    var teamIkuraNum: [Comparison] = []
    /// チーム金イクラ数
    var teamGoldenIkuraNum: [Comparison] = []
    /// クリア率など
    var clearRatio: [Comparison] = []
    /// ブキの支給率
    var weaponProbs: [WeaponProb] = []
    /// スペシャルの支給率
    var specialProbs: [SpecialProb] = []
    /// ランキング
    var goldenEggsWaveRank: [RankingStats] = []
    
    init(startTime: Int, nsaid: String?) {
        self.nsaid = nsaid

        guard let nsaid = nsaid else {
            return
        }
        
        let results = realm.objects(RealmCoopResult.self).filter("startTime=%@ AND pid==%@", startTime, nsaid)
        let players = realm.objects(RealmCoopPlayer.self).filter("ANY link.startTime=%@ AND pid==%@", startTime, nsaid)
        let others = realm.objects(RealmCoopPlayer.self).filter("ANY link.startTime=%@ AND pid!=%@", startTime, nsaid)
        let schedules = realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime)
        
        /// 支給されたブキ一覧
        let weaponList: [WeaponType] = {
            if let schedule = schedules.first {
                if schedule.weaponList.contains(.randomGold) {
                    return [.shooterBlasterBurst, .umbrellaAutoAssault, .chargerSpark, .slosherVase]
                }
                return Array(schedule.weaponList)
            }
            return []
        }()
        // 赤イクラ
        self.ikuraNum = [
            Overview(score: players.average(of: "ikuraNum"), other: others.average(of: "ikuraNum"), caption: "平均赤イクラ数"),
            Overview(score: players.maxIkuraNum(), other: others.maxIkuraNum(), caption: "最高赤イクラ数"),
        ]
        // 金イクラ
        self.goldenIkuraNum = [
            Overview(score: players.average(of: "goldenIkuraNum"), other: others.average(of: "goldenIkuraNum"), caption: "平均金イクラ数"),
            Overview(score: players.maxGoldenIkuraNum(), other: others.maxGoldenIkuraNum(), caption: "最高金イクラ数"),
        ]
        // 被救助数
        self.deadCount = [
            Overview(score: players.average(of: "deadCount"), other: others.average(of: "deadCount"), caption: "平均被救助数"),
            Overview(score: players.maxDeadNum(), other: others.maxDeadNum(), caption: "最高被救助数"),
        ]
        // 救助数平均
        self.helpCount = [
            Overview(score: players.average(of: "helpCount"), other: others.average(of: "helpCount"), caption: "平均救助数"),
            Overview(score: players.maxHelpNum(), other: others.maxHelpNum(), caption: "最高救助数"),
        ]
        // 討伐数
        self.defeatedCount = [
            Overview(score: players.averageDefeatedNum(), other: others.averageDefeatedNum(), caption: "平均オオモノ討伐数"),
            Overview(score: players.maxDefeatedNum(), other: others.maxDefeatedNum(), caption: "最高オオモノ討伐数"),
        ]
        // 各オオモノ討伐数
        self.defeatedIdCount = BossId.allCases.map({ bossId -> Defeated in
            Defeated(score: players.averageDefeatedNum(bossId: bossId), other: others.averageDefeatedNum(bossId: bossId), bossType: bossId)
        })
        // チーム赤イクラ
        self.teamIkuraNum = [
            Comparison(score: results.averageIkuraNum(), other: nil, caption: "平均チーム赤イクラ数"),
            Comparison(score: results.maxIkuraNum(), other: nil, caption: "最高チーム赤イクラ数")
        ]
        // チーム金イクラ
        self.teamGoldenIkuraNum = [
            Comparison(score: results.averageGoldenIkuraNum(), other: nil, caption: "平均チーム金イクラ数"),
            Comparison(score: results.maxGoldenIkuraNum(), other: nil, caption: "最高チーム金イクラ数")
        ]
        
        // クリア率
        self.clearRatio = [
            Comparison(score: results.clearRatio(), other: nil, caption: "クリア率"),
            Comparison(score: results.averageClearWave(), other: nil, caption: "平均クリアWAVE")
        ]
        self.weaponProbs = players.suppliedWeaponProbs(weaponList: weaponList)
        self.specialProbs = players.suppliedSpecialProb()
    }
}

fileprivate extension RealmCoopResult {
    /// 支給されたブキ一覧
    var weaponList: [WeaponType] {
        if let schedule = self.schedule {
            return Array(schedule.weaponList)
        }
        return []
    }
}

extension RealmCoopPlayer {
    /// オオモノ討伐数の合計
    func bossKillCountsSum() -> Int {
        self.bossKillCounts.sum()
    }
    
    /// 指定されたオオモノの討伐数
    func bossKillCounts(bossId: BossId) -> Int {
        self.bossKillCounts[bossId.index]
    }
}

fileprivate extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index {
        Self.allCases.firstIndex(of: self)!
    }
}

fileprivate extension Array where Element: BinaryInteger {
    func average() -> Double? {
        self.isEmpty ? nil : Double(self.reduce(0, +)) / Double(self.count)
    }
}

fileprivate extension Array where Element: BinaryFloatingPoint {
    func average() -> Double? {
        self.isEmpty ? nil : Double(self.reduce(0, +)) / Double(self.count)
    }
}

fileprivate extension RealmSwift.Results where Element == RealmCoopResult {
    func clearRatio() -> Double? {
        if self.isEmpty { return nil }
        return Double(self.filter("isClear==true").count) / Double(self.count) * 100
    }
    
    func averageClearWave() -> Double? {
        if self.isEmpty { return nil }
        return 3.00 - sum(ofProperty: "failureWave") / Double(count)
    }
    
    func maxGoldenIkuraNum() -> Int? {
        let maxValue: Int? = max(ofProperty: "goldenEggs")
        return maxValue
    }
    
    func maxIkuraNum() -> Int? {
        let maxValue: Int? = max(ofProperty: "powerEggs")
        return maxValue
    }
    
    func averageIkuraNum() -> Double? {
        Array(map({ $0.powerEggs })).average()
    }
    
    func averageGoldenIkuraNum() -> Double? {
        Array(map({ $0.goldenEggs })).average()
    }
}

fileprivate extension RealmSwift.Results where Element == RealmCoopPlayer {
    func suppliedWeaponProbs(weaponList: [WeaponType]) -> [StatsModel.WeaponProb] {
        let suppliedWeaponList: [WeaponType] = flatMap({ $0.weaponList })
        let appearances: [(WeaponType, Int)] = weaponList.map({ suppliedWeapon in (suppliedWeapon, suppliedWeaponList.filter({ $0 == suppliedWeapon }).count) })
        let totalCount: Int = appearances.map({ $0.1 }).reduce(0, +)
        return Array(appearances.map({ StatsModel.WeaponProb(weaponType: $0.0, prob: totalCount == .zero ? .zero : Double($0.1) / Double(totalCount)) }).sorted(by: { $0.prob > $1.prob }).prefix(4))
    }
    
    func suppliedSpecialProb() -> [StatsModel.SpecialProb] {
        let suppliedSpecialList: [SpecialId] = compactMap({ $0.specialId })
        let appearances: [(SpecialId, Int)] = SpecialId.allCases.map({ suppliedSpecial in (suppliedSpecial, suppliedSpecialList.filter({ $0 == suppliedSpecial }).count) })
        let totalCount: Int = appearances.map({ $0.1 }).reduce(0, +)
        let value = appearances.map({ StatsModel.SpecialProb(specialId: $0.0, prob: totalCount == .zero ? .zero : Double($0.1) / Double(totalCount)) }).sorted(by: { $0.prob > $1.prob })
        return value
    }
    
    /// 指定されたオオモノの討伐数の配列
    func bossKillCounts(bossId: BossId) -> [Int] {
        map({ $0.bossKillCounts(bossId: bossId )})
    }
    
    func averageDefeatedNum(bossId: BossId) -> Double? {
        bossKillCounts(bossId: bossId).isEmpty ? nil : bossKillCounts(bossId: bossId).average()
    }
    
    func maxDefeatedNum(bossId: BossId) -> Int? {
        bossKillCounts(bossId: bossId).max()
    }
    
    /// オオモノ討伐数の合計の配列
    func bossKillCounts() -> [Int] {
        map({ $0.bossKillCountsSum() })
    }
    
    func maxDefeatedNum() -> Int? {
        bossKillCounts().max()
    }
    
    func averageDefeatedNum() -> Double? {
        bossKillCounts().isEmpty ? nil : Double(bossKillCounts().reduce(0, +)) / Double(bossKillCounts().count)
    }
    
    func maxDeadNum() -> Int? {
        let maxValue: Int? = max(ofProperty: "deadCount")
        return maxValue
    }
    
    func maxHelpNum() -> Int? {
        let maxValue: Int? = max(ofProperty: "helpCount")
        return maxValue
    }
    
    func maxIkuraNum() -> Int? {
        let maxValue: Int? = max(ofProperty: "ikuraNum")
        return maxValue
    }
    
    func maxGoldenIkuraNum() -> Int? {
        let maxValue: Int? = max(ofProperty: "goldenIkuraNum")
        return maxValue
    }
}
