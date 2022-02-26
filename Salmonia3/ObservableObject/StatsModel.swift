//
//  StatsModel.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//

import Foundation
import RealmSwift
import Surge

final class StatsModel: ObservableObject {
    struct Stats: Identifiable {
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
        
        
        let id: UUID = UUID()
        let caption: String
        let score: Float
        let other: Float
    }
    
    var ikuraNum: [Stats] = []
    var goldenIkuraNum: [Stats] = []
    var deadCount: [Stats] = []
    var helpCount: [Stats] = []
    
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
    }
}

fileprivate extension RealmSwift.Results where Element == RealmCoopPlayer {
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
