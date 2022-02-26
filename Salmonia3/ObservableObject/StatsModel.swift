//
//  StatsModel.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//

import Foundation
import RealmSwift
import Surge
import CoreMedia
import SplatNet2

protocol StatsType: Identifiable {
    var id: UUID { get }
    var score: Float { get }
    var other : Float { get }
}

final class StatsModel: ObservableObject {
    class Defeated: StatsType {
        let id: UUID = UUID()
        let score: Float
        let other: Float
        let bossType: BossType.BossId
        
        internal init<T: BinaryFloatingPoint>(score: T?, other: T?, bossType: BossType.BossId) {
            self.bossType = bossType
            self.score = {
                guard let score = score else {
                    return .zero
                }
                return Float(score)
            }()
            self.other = {
                guard let other = other else {
                    return .zero
                }
                return Float(other)
            }()
        }
    }
    
    class Stats: StatsType {
        let id: UUID = UUID()
        let score: Float
        let other: Float
        let caption: String
        
        internal init<T: BinaryFloatingPoint>(score: T?, other: T?, caption: String) {
            self.caption = caption
            self.score = {
                guard let score = score else {
                    return .zero
                }
                return Float(score)
            }()
            self.other = {
                guard let other = other else {
                    return .zero
                }
                return Float(other)
            }()
        }
        
        internal init<T: BinaryInteger>(score: T?, other: T?, caption: String) {
            self.caption = caption
            self.score = {
                guard let score = score else {
                    return .zero
                }
                return Float(score)
            }()
            self.other = {
                guard let other = other else {
                    return .zero
                }
                return Float(other)
            }()
        }
    }
    
    /// 赤イクラ数
    var ikuraNum: [Stats] = []
    /// 金イクラ数
    var goldenIkuraNum: [Stats] = []
    /// 被救助数
    var deadCount: [Stats] = []
    /// 救助数
    var helpCount: [Stats] = []
    /// オオモノ討伐数
    var defeatedCount: [Stats] = []
    /// 各オオモノ討伐数
    var defeatedIdCount: [Defeated] = []
    init() {}
    
    init(startTime: Int, nsaid: String?) {
        guard let realm = try? Realm(),
              let nsaid = nsaid
        else {
            return
        }
        
        let results = realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime)
        let players = realm.objects(RealmCoopPlayer.self).filter("ANY result.startTime=%@ AND pid==%@", startTime, nsaid)
        let others = realm.objects(RealmCoopPlayer.self).filter("ANY result.startTime=%@ AND pid!=%@", startTime, nsaid)
        
        print(results.count, others.count, players.count)
        
        // 赤イクラ平均と金イクラ平均
        self.ikuraNum = [
            Stats(score: players.average(of: "ikuraNum"), other: others.average(of: "ikuraNum"), caption: "平均赤イクラ数"),
            Stats(score: players.maxIkuraNum(), other: others.maxIkuraNum(), caption: "最高赤イクラ数"),
        ]
        self.goldenIkuraNum = [
            Stats(score: players.average(of: "goldenIkuraNum"), other: others.average(of: "goldenIkuraNum"), caption: "平均金イクラ数"),
            Stats(score: players.maxGoldenIkuraNum(), other: others.maxGoldenIkuraNum(), caption: "最高金イクラ数"),
        ]
        self.deadCount = [
            Stats(score: players.average(of: "deadCount"), other: others.average(of: "deadCount"), caption: "平均被救助数"),
            Stats(score: players.maxDeadNum(), other: others.maxDeadNum(), caption: "最高被救助数"),
        ]
        self.helpCount = [
            Stats(score: players.average(of: "helpCount"), other: others.average(of: "helpCount"), caption: "平均救助数"),
            Stats(score: players.maxHelpNum(), other: others.maxHelpNum(), caption: "最高救助数"),
        ]
        self.defeatedCount = [
            Stats(score: players.averageDefeatedNum(), other: others.averageDefeatedNum(), caption: "平均オオモノ討伐数"),
            Stats(score: players.maxDefeatedNum(), other: others.maxDefeatedNum(), caption: "最高オオモノ討伐数"),
        ]
        self.defeatedIdCount = BossType.BossId.allCases.map({ bossId -> Defeated in
            Defeated(score: players.averageDefeatedNum(bossId: bossId), other: others.averageDefeatedNum(bossId: bossId), bossType: bossId)
        })
    }
}

fileprivate extension RealmCoopPlayer {
    /// オオモノ討伐数の合計
    func bossKillCountsSum() -> Int {
        self.bossKillCounts.sum()
    }
    
    /// 指定されたオオモノの討伐数
    func bossKillCounts(bossId: BossType.BossId) -> Int {
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

fileprivate extension RealmSwift.Results where Element == RealmCoopPlayer {
    /// 指定されたオオモノの討伐数の配列
    func bossKillCounts(bossId: BossType.BossId) -> [Int] {
        map({ $0.bossKillCounts(bossId: bossId )})
    }
    
    func averageDefeatedNum(bossId: BossType.BossId) -> Double? {
        bossKillCounts(bossId: bossId).isEmpty ? nil : bossKillCounts(bossId: bossId).average()
    }
    
    func maxDefeatedNum(bossId: BossType.BossId) -> Int? {
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
