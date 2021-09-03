//
//  StatsWaveView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/15.
//

import Foundation
import SwiftUI

struct StatsWaveView: View {
    @EnvironmentObject var stats: CoopShiftStats

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 200)), count: 3), alignment: .center, spacing: nil, pinnedViews: []) {
                ForEach(stats.resultWave.indices) { index in
                    // EventId 1, 2, 3は干潮が存在せず、6は干潮しか存在しない
                    if !((stats.resultWave[index].event >= 1 && stats.resultWave[index].event <= 3) && stats.resultWave[index].tide == 0) &&
                        !(stats.resultWave[index].event == 6 && stats.resultWave[index].tide != 0)
                        {
                        CircleWaveView(tide: (stats.resultWave[index].tide + 1) * 30)
                            .overlay(Text(EventType.init(rawValue: stats.resultWave[index].event)!.eventType.localized), alignment: .top)
                            .overlay(Text(stats.resultWave[index].goldenEggs.stringValue).splatfont2(size: 22))
                    } else {
                        CircleWaveView(tide: (stats.resultWave[index].tide + 1) * 30)
                            .hidden()
                    }
                }
            }
        }
        .splatfont2(size: 14)
    }
}

