//
//  StatsTabView.swift
//  Salmonia3
//
//  Created by devonly on 2021/07/01.
//

import SwiftUI

struct CoopShiftStatsView: View {
    
    var stats: CoopShiftStats
    var startTime: Int

    init(startTime: Int) {
        self.startTime = startTime
        self.stats = CoopShiftStats(startTime: startTime)
    }
    
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
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle(.TITLE_SHIFT_STATS)
    }
}
