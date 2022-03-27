//
//  Dashboard.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/27.
//  
//

import Foundation
import SwiftUI
import SwiftyChart

enum Dashboard {}

extension Dashboard {
    struct BossDefeatedRatio: View {
#if DEBUG
    let stats: RadarChartStats? = RadarChartStats(
        player: RadarChartSet(data: Array(repeating: 1, count: 9), caption: "", color: .blue),
        other: RadarChartSet(data: Array(repeating: 0.8, count: 9), caption: "", color: .red))
#else
    let stats: RadarChartStats?
#endif
        var body: some View {
            if let stats = stats {
                HStack(content: {
                    RadarChartBossLabel()
                        .background(RadarChart(data: [stats.player, stats.other]), alignment: .center)
                })
                    .padding(24)
                    .aspectRatio(16/9, contentMode: .fit)
                    .background(Color.red.opacity(0.3))
//                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.black))
            }
        }
    }
    
    struct WaveClearRatio: View {
#if DEBUG
    let stats: [PieChartModel] = [
        PieChartModel(value: 10, color: .blue, title: ""),
        PieChartModel(value: 30, color: .yellow, title: ""),
        PieChartModel(value: 40, color: .red, title: ""),
        ]
#else
    let stats: RadarChartStats?
#endif
        var body: some View {
            PieChart(data: stats)
                .aspectRatio(16/9, contentMode: .fit)
                .background(RoundedRectangle(cornerRadius: 6).fill(Color.black))
                .padding()
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard.BossDefeatedRatio()
            .previewLayout(.fixed(width: 400, height: 400))
        Dashboard.WaveClearRatio()
            .previewLayout(.fixed(width: 320, height: 180))
    }
}
