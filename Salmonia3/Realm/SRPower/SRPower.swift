//
//  SRPower.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/31.
//

import Foundation
import RealmSwift
import SwiftUI

extension RealmPlayerResult {
    var srpower: Double {
        let bossrate: [[Int]] = [[1783, 1609, 2649, 1587, 1534, 1563, 1500, 1783, 2042]]
        let bias: Double = calcBias(self.result.first!, self.pid)
        let baserate: Int = Array(zip(self.bossKillCounts, bossrate[0])).map{ $0 * $1 }.reduce(0, +) / max(1, self.bossKillCounts.sum())
        
        return Double(Double(baserate) * bias).round
    }
    
    var matching: Int {
        return RealmManager.shared.playerResults(playerId: self.pid).count
    }
}

private func calcBias(_ result: RealmCoopResult, _ nsaid: String) -> Double {
    let player: RealmPlayerResult = result.player.filter("pid=%@", nsaid).first!
    let base: [Double] = [
        Double((result.dangerRate * 3) / 5 + 120) / 160, // MAX
        Double((result.dangerRate * 3) / 5 + 80) / 160, // BASE
    ]
    let bias: [Double] = [
        Double(player.bossKillCounts.sum() * 99) / Double(17 * result.bossCounts.sum()),
        Double((result.dangerRate * 3) / 5 + 80) / 160 + Double(player.goldenIkuraNum * 3 - result.wave.sum(ofProperty: "quotaNum")) / (9 * 160)
    ]
    let quota: [Bool] = [
        (min(result.wave.sum(ofProperty: "quotaNum"), result.wave.sum(ofProperty: "goldenIkuraNum")) / 5) <= player.goldenIkuraNum, // ノルマか納品数の少ない方の20%
        min(result.bossKillCounts.sum() / 5, result.bossCounts.sum() / 6) <= player.bossKillCounts.sum(), // 討伐数の25%か出現数の20%の小さい方のどちらか
    ]

    switch (quota[0], quota[1]) {
    case (true, true): // どちらもした
        switch (bias.min()! >  base.max()!) {
        case true: // 抜群の成績
            return bias.reduce(0, +) / 2
        case false: // 平均以上の働き
            return min(base.max()!, bias.max()!)
        }
    case (true, false): // 納品だけはした
        return min(base.min()!, bias.reduce(0, +) / 2)
    case (false, true): // 討伐だけはした
        return bias.reduce(0, +) / 2
    case (false, false): // どちらもしてない
        return bias.min()!
    }
}

private extension Double {
    var round: Double {
        return Double(Int(self * 100)) / Double(100)
    }
}
