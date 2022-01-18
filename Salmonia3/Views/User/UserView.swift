//
//  UserView.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
import SwiftyUI
import RealmSwift
import SplatNet2
import SwiftyChart

struct UserView: View {
    @EnvironmentObject var service: AppManager
    
    var body: some View {
        NavigationView(content: {
            if let nsaid = service.account?.credential.nsaid {
                let stats: UserStatsModel = UserStatsModel(nsaid: nsaid)
                UserStatsView(user: stats)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing, content: {
                            NavigationLink(destination: SettingView(), label: {
                                Image(systemName: .Gearshape)
                            })
                        })
                    })
            } else {
                ScrollView(content: {})
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing, content: {
                            NavigationLink(destination: SettingView(), label: {
                                Image(systemName: .Gearshape)
                            })
                        })
                    })
            }
        })
    }
}

struct UserStatsView: View {
    @State var selection: Int = 0
    @StateObject var user: UserStatsModel
    
    var WaveAnalysis: some View {
        Section(content: {
            PieChart(data: user.result)
        }, header: {
            Text("HEADER.WAVE.ANALYSIS")
        })
    }
    
    var BossDefeatedAnalysis: some View {
        Section(content: {
            RadarChartBossLabel()
                .scaledToFit()
                .padding(.horizontal)
                .background(RadarChart(data: [user.defeated.player, user.defeated.other]), alignment: .center)
        }, header: {
            Text("HEADER.BOSS.DEFEATED")
        })
    }
    
    var UserStatsAnalysis: some View {
        Section(content: {
            RadarChartUserStats()
                .scaledToFit()
                .padding(.horizontal)
                .background(RadarChart(data: [user.stats.player, user.stats.other]), alignment: .center)
        })
    }
    
    var body: some View {
        TabView(selection: $selection, content: {
            WaveAnalysis
                .tabItem({
                    
                })
        })
            .tabViewStyle(.page)
    }
}

internal struct RadarChartBossLabel: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let midX: CGFloat = geometry.frame(in: .local).midX
            let midY: CGFloat = geometry.frame(in: .local).midY
            let count: CGFloat = CGFloat(BossType.BossId.allCases.count)
            let radius: CGFloat = min(midX, midY)
            
            ForEach(Array(BossType.BossId.allCases.enumerated()), id: \.offset) { index, bossId in
                Image(bossId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35, alignment: .center)
                    .background(Circle().fill(Color.originary))
                    .position(
                        x: midX - radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
    }
}

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
                    .frame(width: 35, height: 35, alignment: .center)
                    .scaledToFit()
                    .background(Circle().fill(Color.originary))
                    .position(
                        x: midX - radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
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
        return objects(RealmCoopPlayer.self).filter("pid=%@ and any result.startTime=%@", nsaid, startTime)
    }
}

extension Array: Identifiable where Element == PieChartModel {
    public var id: UUID { UUID() }
    
    public var totalCount: Int { Int(map({ $0.value }).reduce(0, +)) }
}
//
//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
