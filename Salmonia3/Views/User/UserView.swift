//
//  UserView.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SwiftyChart
import RealmSwift
import SplatNet2

struct UserView: View {
//    @StateObject var stats: UserStatsService = UserStatsService()
    
    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 70, maximum: 200), alignment: .top), count: 3), spacing: 24, content: {
                    SignIn.User()
                    SignIn.SplatNet2()
                    SignIn.Twitter()
                    SignIn.SalmonStats()
                    SignIn.LightSwitch()
                    SignIn.WriteReview()
                    SignIn.Product()
                    SignIn.Option()
                })
            })
            .navigationTitle("ダッシュボード")
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(LoadingService())
            .font(systemName: .Splatfont2, size: 16)
        })
        .navigationViewStyle(.split)
    }
}

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
                    .frame(width: 24, height: 24, alignment: .center)
                    .scaledToFit()
                    .background(Circle().fill(Color.originary))
                    .position(
                        x: midX - radius * sin(2 * .pi * CGFloat(index) / count - .pi),
                        y: midY + radius * cos(2 * .pi * CGFloat(index) / count - .pi)
                    )
            }
        })
        .scaledToFit()
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


struct User_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
    }
}
