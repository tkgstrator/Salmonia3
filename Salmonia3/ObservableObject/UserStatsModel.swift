//
//  UserStatsModel.swift
//  Salmonia3
//
//  Created by devonly on 2022/01/04.
//

import Foundation
import RealmSwift
import SwiftyChart
import SplatNet2
import SalmonStats
import SwiftUI

final class UserStatsService: ObservableObject {
    /// バイト回数
    internal var jobNum: Int = 0
    /// 全体のリザルト
    internal var result: [PieChartModel] = []
    /// WAVE毎のリザルト
    internal var waves: [[PieChartModel]] = []
    /// オオモノ討伐
    internal var defeated: RadarChartStats?
    /// 統計
    internal var stats: RadarChartStats?
    
    init() {
        let session: SalmonStats = SalmonStats()
        guard let nsaid = session.account?.credential.nsaid else {
            return
        }
        let realm = try! Realm()
                let results = realm.results(nsaid: nsaid)
        let playerResults = realm.playerResults(nsaid: nsaid)
        
        self.jobNum = results.count
        self.result = [
            PieChartModel(value: Float(results.filter("isClear=%@", true).count), color: .blue, title: "JOB.RESULT.SUCCESS"),
            PieChartModel(value: Float(results.filter("failureReason=%@", FailureReason.timeLimit.rawValue).count), color: .red, title: "JOB.RESULT.TIMELIMIT"),
            PieChartModel(value: Float(results.filter("failureReason=%@", FailureReason.wipeOut.rawValue).count), color: .green, title: "JOB.RESULT.WIPEOUT"),
        ]
        self.waves = [1, 2, 3].map({ result in
            // 各WAVEで失敗したリザルトを取得
            let results = results.filter("failureWave=%@", result)
            return [
                PieChartModel(value: Float(results.filter("failureReason=%@", FailureReason.timeLimit.rawValue).count), color: .red, title: "JOB.RESULT.TIMELIMIT"),
                PieChartModel(value: Float(results.filter("failureReason=%@", FailureReason.wipeOut.rawValue).count), color: .green, title: "JOB.RESULT.WIPEOUT"),
            ]
        })
        
        let playerTotalBossKillCounts: [Float] = flat(of: playerResults.map({ $0.bossKillCounts.map({ Float($0) }) }))
        let totalBossKillCounts: [Float] = flat(of: results.map({ $0.bossKillCounts.map({ Float($0) }) }))
        let totalBossCounts: [Float] = flat(of: results.map({ $0.bossCounts.map({ Float($0) }) }))
        self.defeated = RadarChartStats(
            player: RadarChartSet(
                data: avg(of: div(sub(totalBossKillCounts, playerTotalBossKillCounts), div: 3), div: totalBossCounts),
                caption: "",
                color: .yellow
            ),
            other: RadarChartSet(
                data: avg(of: playerTotalBossKillCounts, div: totalBossCounts),
                caption: "",
                color: .blue
            )
        )

        self.stats = RadarChartStats(
            player: RadarChartSet(
                data: [
                    playerResults.average(of: "goldenIkuraNum") / results.average(of: "goldenEggs"),
                    playerResults.average(of: "ikuraNum") / results.average(of: "powerEggs"),
                    playerResults.average(of: "deadCount") / results.deadCountAvg(),
                    playerResults.average(of: "helpCount") / results.helpCountAvg()
                ],
                caption: "",
                color: .yellow
            ),
            other: RadarChartSet(
                data: [
                    playerResults.average(of: "goldenIkuraNum") / results.average(of: "goldenEggs"),
                    playerResults.average(of: "ikuraNum") / results.average(of: "powerEggs"),
                    playerResults.average(of: "deadCount") / results.deadCountAvg(),
                    playerResults.average(of: "helpCount") / results.helpCountAvg()
                ],
                caption: "",
                color: .blue
            )
        )
    }
}

final internal class RadarChartStats {
    internal init(player: RadarChartSet, other: RadarChartSet) {
        self.player = player
        self.other = other
    }
    
    let player: RadarChartSet
    let other: RadarChartSet
}

internal func flat<T: Numeric>(of arrays: Array<Array<T>>) -> Array<T> {
    if let first = arrays.first {
        var sum: [T] = Array(repeating: 0, count: first.count)
        let _ = arrays.map({ sum = sum.add($0) })
        return sum
    }
    return []
}

internal func sub<T: Numeric>(_ a: Array<T>, _ b: Array<T>) -> Array<T> {
    zip(a, b).map({ $0.0 - $0.1 })
}

internal func div<T: FloatingPoint>(_ a: Array<T>, div: T) -> Array<T> {
    a.map({ $0 / div})
}

internal func avg<T: FloatingPoint>(of arrays: Array<T>, div: Array<T>) -> Array<T> {
    zip(arrays, div).map({ $0.0 / $0.1 })
}

extension RealmSwift.Results where Element == RealmCoopPlayer {
    func average(of ofProperty: String) -> Float {
        self.average(ofProperty: ofProperty) ?? .zero
    }
}

extension RealmSwift.Results where Element == RealmCoopResult {
    func average(of ofProperty: String) -> Float {
        (self.average(ofProperty: ofProperty) ?? .zero) / 4.0
    }
    
    func deadCountAvg() -> Float {
        let totalDeadCount: Int = self.map({ $0.player.map({ $0.deadCount }).reduce(0, +) }).reduce(0, +)
        let totalPlayercount: Int = self.map({ $0.player.count }).reduce(0, +)
        return Float(totalDeadCount) / Float(totalPlayercount)
    }
    
    func helpCountAvg() -> Float {
        let totalDeadCount: Int = self.map({ $0.player.map({ $0.deadCount }).reduce(0, +) }).reduce(0, +)
        let totalPlayercount: Int = self.map({ $0.player.count }).reduce(0, +)
        return Float(totalDeadCount) / Float(totalPlayercount)
    }
}
