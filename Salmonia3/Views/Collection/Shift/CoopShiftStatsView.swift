//
//  StatsTabView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/01.
//

import SwiftUI

struct CoopShiftStatsView: View {
    
    @State var stats: CoopShiftStats = CoopShiftStats()
    @State var selection: Int = 0
    var startTime: Int

    var body: some View {
        TabView(selection: $selection) {
            StatsView(startTime: startTime, stats: stats)
                .tabItem {
                    Image(systemName: "info.circle")
                }
                .tag(0)
            // 記録が0でないなら
            if stats.overview.jobNum != nil {
                StatsChartView(stats: stats)
                    .tabItem {
                        Image(systemName: "chart.pie")
                    }
                    .tag(1)
                StatsWaveView(stats: stats)
                    .tabItem {
                        Image(systemName: "moon.stars")
                    }
                    .tag(2)
                // ランダムブキがあるなら表示
                if RealmManager.shared.shift(startTime: startTime).rareWeapon != nil {
                    StatsWeaponView(stats: stats)
                        .tabItem {
                            Image(systemName: "questionmark")
                        }
                        .tag(3)
                }
            }
        }
        .onAppear {
            stats = CoopShiftStats(startTime: startTime)
        }
        .navigationTitle(.TITLE_SHIFT_STATS)
    }
}
