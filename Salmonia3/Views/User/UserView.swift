//
//  UserView.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
import SwiftyUI
import SwiftyChart
import RealmSwift
import SplatNet2

struct UserView: View {
    @StateObject var stats: UserStatsService = UserStatsService()
    
    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                Dashboard.WaveClearRatio(result: stats.result)
//                Dashboard_Defeated(stats: stats.defeated)
            })
            .navigationTitle("ダッシュボード")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    NavigationLink(destination: SettingView(), label: {
                        Image(systemName: .Gearshape)
                    })
                })
            })
            .font(systemName: .Splatfont2, size: 16)
        })
        .navigationViewStyle(.split)
    }
}

//struct UserStatsView: View {
//    @State var selection: Int = 0
//    @StateObject var user: UserStatsModel
//
//    var WaveAnalysis: some View {
//        PieChart(data: user.result)
//    }
//
//    var BossDefeatedAnalysis: some View {
//        Section(content: {
//            RadarChartBossLabel()
//                .scaledToFit()
//                .padding(.horizontal)
//                .background(RadarChart(data: [user.defeated.player, user.defeated.other]), alignment: .center)
//        }, header: {
//            Text("HEADER.BOSS.DEFEATED")
//        })
//    }
//
//    var UserStatsAnalysis: some View {
//        Section(content: {
//            RadarChartUserStats()
//                .scaledToFit()
//                .padding(.horizontal)
//                .background(RadarChart(data: [user.stats.player, user.stats.other]), alignment: .center)
//        })
//    }
//
//    var body: some View {
//        TabView(selection: $selection, content: {
//            WaveAnalysis
//                .tabItem({
//
//                })
//        })
//            .tabViewStyle(.page)
//    }
//}

/// オオモノ討伐率グラフのラベル
internal struct RadarChartBossLabel: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let midX: CGFloat = geometry.frame(in: .local).midX
            let midY: CGFloat = geometry.frame(in: .local).midY
            let count: CGFloat = CGFloat(BossId.allCases.count)
            let radius: CGFloat = min(midX, midY)
            
            ForEach(Array(BossId.allCases.enumerated()), id: \.offset) { index, bossId in
                Image(bossId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
                    .background(Circle().fill(Color.originary))
                    .position(
                        x: midX - radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
    }
}

/// レーダーチャートを表示
internal struct RadarChartUserStats: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let midX: CGFloat = geometry.frame(in: .local).midX
            let midY: CGFloat = geometry.frame(in: .local).midY
            let count: CGFloat = CGFloat(ResultType.allCases.count)
            let radius: CGFloat = min(midX, midY)
            
            ForEach(Array(ResultType.allCases.enumerated()), id: \.offset) { index, resultId in
                Image(resultId)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .scaledToFit()
                    .background(Circle().fill(Color.originary))
                    .position(
                        x: midX - radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
        .scaledToFit()
        .frame(maxWidth: 200)
    }
}

extension Realm {
    /// リザルト一覧を返す
    func results(nsaid: String, startTime: Int? = nil) -> RealmSwift.Results<RealmCoopResult> {
        guard let startTime = startTime else {
            return objects(RealmCoopResult.self).filter("pid=%@", nsaid)
        }
        return objects(RealmCoopResult.self).filter("pid=%@ AND startTime=%@", nsaid, startTime)
    }
    
    /// プレイヤーのリザルト一覧を返す
    func playerResults(nsaid: String, startTime: Int? = nil) -> RealmSwift.Results<RealmCoopPlayer> {
        guard let startTime = startTime else {
            return objects(RealmCoopPlayer.self).filter("pid=%@", nsaid)
        }
        return objects(RealmCoopPlayer.self).filter("pid=%@ and any link.startTime=%@", nsaid, startTime)
    }
}

extension Array: Identifiable where Element == PieChartModel {
    public var id: UUID { UUID() }
    
    public var totalCount: Int { Int(map({ $0.value }).reduce(0, +)) }
}
