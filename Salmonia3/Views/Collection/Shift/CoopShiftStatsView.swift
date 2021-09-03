//
//  StatsTabView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/01.
//

import SwiftUI
import SwiftUIX

struct CoopShiftStatsView: View {
    @EnvironmentObject var stats: CoopShiftStats
    @State var selection: Int = 0
    var startTime: Int

    var body: some View {
        switch RealmManager.shared.shiftTimeList(nsaid: manager.playerId).contains(startTime) {
        case true:
            switch RealmManager.shared.shift(startTime: startTime).rareWeapon != nil {
            case true:
                PaginationView {
                    StatsView(startTime: startTime, stats: stats)
                    StatsChartView(stats: stats)
                    StatsWaveView(stats: stats)
                    StatsWeaponView(stats: stats)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(.TITLE_SHIFT_STATS)
            case false:
                PaginationView {
                    StatsView(startTime: startTime, stats: stats)
                    StatsChartView(stats: stats)
                    StatsWaveView(stats: stats)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(.TITLE_SHIFT_STATS)
            }
        case false:
            PaginationView {
                StatsView(startTime: startTime, stats: stats)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(.TITLE_SHIFT_STATS)
        }
    }
}
