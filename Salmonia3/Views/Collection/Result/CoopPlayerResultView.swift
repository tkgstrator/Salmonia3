//
//  CoopPlayerResultView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/10.
//

import SwiftUI
import RealmSwift
import URLImage

struct CoopPlayerResultView: View {
    @AppStorage("FEATURE_OTHER_05") var resultStyle: ResultStyle = .salmonrec
    let colors: [Color] = [.venitianred, .deepskyblue, .salam, .turbo]
    let bossCounts: [Int]
    let result: RealmCoopResult
    //    let bossKillCounts: [Int]
    let playerBossKillCounts: [[Int]]
    
    init(result: RealmCoopResult) {
        self.result = result
        self.bossCounts = Array(result.bossCounts)
//        self.bossKillCounts = Array(result.bossKillCounts)
        self.playerBossKillCounts = Array(result.player.map({ Array($0.bossKillCounts) })).transpose()
    }
  
    var body: some View {
        switch resultStyle {
//        case .lemontea:
//            LemonTeaView(result: result)
        case .salmonrec:
            BarChartView(player: result.player, bossCounts: bossCounts, playerBossKillCounts: playerBossKillCounts)
        case .barleyural:
            CircleChartView(player: result.player, bossCounts: bossCounts, playerBossKillCounts: playerBossKillCounts)
//        default:
//            CircleChartView(player: result.player, bossCounts: bossCounts, playerBossKillCounts: playerBossKillCounts)
        }
    }
}

// 二次元行列の転置行列を計算する
extension Array where Element: Collection, Element.Index == Int {
    func transpose() -> [[Element.Element]] {
        return self.isEmpty ? [] : (0...(self.first!.endIndex - 1)).map { i -> [Element.Element] in self.map { $0[i] } }
    }
}

struct CoopPlayerResultView_Previews: PreviewProvider {
    static let result = RealmManager.shared.results.first!
    static var previews: some View {
        CoopPlayerResultView(result: RealmManager.shared.results.first!)
            .previewLayout(.fixed(width: 414, height: 896))
    }
}
