//
//  StatsTabView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/01.
//

import SwiftUI

struct CoopShiftStatsView: View {
    
    @State var stats: CoopShiftStats = CoopShiftStats()
    var startTime: Int

    var body: some View {
        TabView {
            StatsView(startTime: startTime, stats: stats)
                .tag(0)
            // 記録が0でないなら
            if stats.overview.jobNum != nil {
                StatsChartView(stats: stats)
                    .tag(1)
                StatsWaveView(stats: stats)
                    .tag(2)
                // ランダムブキがあるなら表示
                if RealmManager.shared.shift(startTime: startTime).rareWeapon != nil {
                    StatsWeaponView(stats: stats)
                        .tag(3)
                }
            }
        }
        .onWillAppear {
            stats = CoopShiftStats(startTime: startTime)
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle(.TITLE_SHIFT_STATS)
    }
}
