//
//  CoopPlayerView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/10.
//

import SwiftUI
import RealmSwift

struct CoopPlayerView: View {
    var player: RealmPlayerResult
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(spacing: 3) {
                    Text(player.name.stringValue)
                        .splatfont2(.white, size: 18)
                        .frame(height: 12)
                        .padding(.bottom, 5)
                    HStack {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
                            SRImage(from: Special(rawValue: player.specialId), size: CGSize(width: 35, height: 35))
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 35)
                            ForEach(player.weaponList.indices, id: \.self) { index in
                                Image(String(player.weaponList[index]).imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 35)
                            }
                        }
                    }
                    Text("RESULT_BOSS_DEFEATED_\(player.bossKillCounts.sum())")
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                }
                Spacer()
                VStack(spacing: 0) {
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack {
                            Spacer()
                            Text("RESULT_RATING_\(String(player.srpower))")
                                .frame(height: 10)
                        }
                        HStack {
                            Spacer()
//                            Text("RESULT_RATING_\(String(player.srpower))")
//                                .frame(height: 10)
                        }
                    }
                    .frame(height: 12)
                    .splatfont2(.orange, size: 13)
                    Spacer()
                    HStack {
                        HStack {
                            Image("49c944e4edf1abee295b6db7525887bd")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                            Text(verbatim: "x \(player.goldenIkuraNum)")
                        }
                        HStack {
                            Image("f812db3e6de0479510cd02684131e15a")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                            Text(verbatim: "x \(player.ikuraNum)")
                        }
                    }
                    HStack {
                        HStack {
                            Image("657f8b8da628ef83cf69101b6817150a")
                                .resizable()
                                .frame(width: 33.4, height: 12.8)
                            Spacer()
                            Text(verbatim: "x \(player.helpCount)")
                        }
                        HStack {
                            Image("2e8d6dbf9112a879d4ceb15403d10a78")
                                .resizable()
                                .frame(width: 33.4, height: 12.8)
                            Spacer()
                            Text(verbatim: "x \(player.deadCount)")
                        }
                    }
                }
            }
        }
        .splatfont2(.white, size: 16)
        .frame(height: 80)
    }
}

fileprivate func calcBias(_ result: RealmCoopResult, _ nsaid: String) -> Double {
    let player: RealmPlayerResult = result.player.filter("pid=%@", nsaid).first!
    let base: [Double] = [
        Double((result.dangerRate.value! * 3) / 5 + 120) / 160, // MAX
        Double((result.dangerRate.value! * 3) / 5 + 80) / 160, // BASE
    ]
    let bias: [Double] = [
        Double(player.bossKillCounts.sum() * 99) / Double(17 * result.bossCounts.sum()),
        Double((result.dangerRate.value! * 3) / 5 + 80) / 160 + Double(player.goldenIkuraNum * 3 - result.wave.sum(ofProperty: "quotaNum")) / (9 * 160)
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

fileprivate extension RealmPlayerResult {
    var srpower: Double {
        let bossrate: [[Int]] =
            [[1783, 1609, 2649, 1587, 1534, 1563, 1500, 1783, 2042]]
        let bias: Double = calcBias(self.result.first!, self.pid!)
        let baserate: Int = Array(zip(self.bossKillCounts, bossrate[0])).map{ $0 * $1 }.reduce(0, +) / max(1, self.bossKillCounts.sum())
        
        return Double(Double(baserate) * bias).round
    }
}

fileprivate extension Double {
    var round: Double {
        return Double(Int(self * 100)) / Double(100)
    }
}
